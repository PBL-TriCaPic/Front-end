// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';
import '../Friend/Friend_Profile.dart';
import '../Profile/Profile.dart';
import '../theme_setting/Color_Scheme.dart';
import 'package:lottie/lottie.dart';
import '../theme_setting/HTTP_request.dart';
import '../theme_setting/SharedPreferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// テキスト入力フィールドのコントローラ
TextEditingController _textController = TextEditingController();

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: const SearchScreenpage(),
    );
  }
}

class SearchScreenpage extends StatefulWidget {
  const SearchScreenpage({super.key});

  @override
  State<SearchScreenpage> createState() => MyHomePageState();
}

class MyHomePageState extends State<SearchScreenpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black,
        title: _searchTextField(_textController),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _defaultListView(),
      ),
    );
  }

  Widget _searchTextField(TextEditingController textController) {
    return TextField(
      controller: textController,
      autofocus: false,
      // onChanged: (String text) {
      //   if (_debounce?.isActive ?? false) _debounce!.cancel();
      //   _debounce = Timer(const Duration(milliseconds: 500), () {
      //     _performSearch(text);
      //   });
      // },
      onSubmitted: (String text) {
        // キーボードの決定ボタンが押されたときの処理
        _performSearch(text);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            textController.clear();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            width: 0.8,
            style: BorderStyle.solid,
          ),
        ),
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        hintText: "検索",
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _defaultListView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/Search_Friend.json',
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  '友達を探そう！！',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _performSearch(String entertext) async {
    try {
      String userId = entertext.startsWith('@') ? entertext : '@$entertext';
      final userData = await ApiService.fetchUserData(userId);

      // fetchUserDataが正常にデータを取得した場合
      _navigateToUserDetails(context, userData['name'], userId);
    } catch (e) {
      // エラーが発生した場合
    }
  }

  void _navigateToUserDetails(
      BuildContext context, String username, String userID) async {
    // SharedPreferencesから現在のログイン中のユーザーIDを取得
    String? loggedInUserId = await SharedPrefs.getUserId();

    try {
      if (loggedInUserId != null && userID == loggedInUserId) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountScreen(),
          ),
        );

        // 画面が戻ってきた際に再度データを取得
        // _fetchFriendsList();
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UserDetailsScreen(username: username, userID: userID),
          ),
        );

        // 画面が戻ってきた際に再度データを取得
        // _fetchFriendsList();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('エラー'),
            content: const Text('ユーザーが見つかりませんでした。'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
