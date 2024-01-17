// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously, use_super_parameters

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Friend/Friend_Profile.dart';
import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';

import '../Profile/Profile.dart';
import '../theme_setting/HTTP_request.dart';
import '../theme_setting/SharedPreferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class FriendrequestList extends StatefulWidget {
  final String? userId;

  const FriendrequestList({Key? key, required this.userId}) : super(key: key);

  @override
  State<FriendrequestList> createState() => _FriendrequestListpageState();
}

class _FriendrequestListpageState extends State<FriendrequestList> {
  late String userId;
  List<String> usernames = [];
  List<String> userIDs = [];
  List<String?> iconImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = widget.userId!;
    _fetchFriendsList();
  }

  Future<void> _fetchFriendsList() async {
    try {
      // 非同期処理が開始したことを通知
      // setState(() {
      //   isLoading = true;
      // });

      // ここでfetchFriendsListを呼び出してデータを取得
      List friendsList = await ApiService.fetchFriendRequestsList(userId);

      // データをusernamesとuserIDsにセット
      setState(() {
        usernames =
            friendsList.map((friend) => friend['name'] as String).toList();
        userIDs =
            friendsList.map((friend) => friend['userId'] as String).toList();
        iconImages = friendsList
            .map((friend) => friend['iconImage'] as String?)
            .toList();
        isLoading = false; // 非同期処理が完了したことを通知
      });
    } catch (e) {
      // エラーハンドリング
      setState(() {
        isLoading = false; // エラー時も非同期処理が完了したことを通知
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フレンドリクエスト一覧'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // 前の画面に戻る
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // データ取得中の場合はインジケーターを表示
          : ListView.builder(
              itemCount: usernames.length,
              itemBuilder: (context, index) {
                final username = usernames[index];
                final userID = userIDs[index];
                final iconImage =
                    iconImages[index] ?? ''; // iconImageがnullの場合は空の文字列を使用

                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 50.0),
                  leading: SizedBox(
                    width: 65, // アイコンの望ましい幅
                    height: 65, // アイコンの望ましい高さ
                    //color: iconImage.isNotEmpty ? null : Colors.black,
                    child: iconImage.isNotEmpty
                        ? CircleAvatar(
                            radius: 20, // 望ましい半径
                            backgroundImage: MemoryImage(
                              base64.decode(iconImage),
                            ),
                          )
                        : const Icon(
                            Icons.account_circle_outlined,
                            size: 65,
                            //color: Colors.
                          ), // iconImageが空の場合はデフォルトのアイコンを表示
                  ),
                  title: Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(userID),
                  onTap: () {
                    _navigateToUserDetails(context, username, userID);
                  },
                );
              },
            ),
    );
  }

  void _navigateToUserDetails(
      BuildContext context, String username, String userID) async {
    // SharedPreferencesから現在のログイン中のユーザーIDを取得
    String? loggedInUserId = await SharedPrefs.getUserId();

    if (loggedInUserId != null && userID == loggedInUserId) {
      // 目的のユーザーIDがログイン中のユーザーIDと一致する場合、AccountScreenに遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AccountScreen(),
        ),
      ).then((value) {
        // 画面が戻ってきた際に再度データを取得
        _fetchFriendsList();
      });
    } else {
      // 目的のユーザーIDが異なる場合、UserDetailsScreenに遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserDetailsScreen(username: username, userID: userID),
        ),
      ).then((value) {
        // 画面が戻ってきた際に再度データを取得
        _fetchFriendsList();
      });
    }
  }
}
