// ignore_for_file: file_names, no_logic_in_create_state

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Friend/Friend_List.dart';

import '../theme_setting/HTTP_request.dart';
//import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';

// final ThemeData lightTheme =
//     ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class UserDetailsScreen extends StatelessWidget {
  final String username;
  final String userID;

  const UserDetailsScreen({
    super.key,
    required this.username,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return FriendPage(username: username, userID: userID);
  }
}

class FriendPage extends StatefulWidget {
  final String username;
  final String userID;

  const FriendPage({
    super.key,
    required this.username,
    required this.userID,
  });

  @override
  State<FriendPage> createState() =>
      MyHomePageState(username: username, userID: userID);
}

class MyHomePageState extends State<FriendPage> {
  final String username;
  final String userID;

  Uint8List? decodedprofile;
  int? friendCount;
  int? postsCount;
  String? bio;

  bool isFollowing = false; // フォロー状態を管理する変数

  MyHomePageState({
    required this.username,
    required this.userID,
  });

  @override
  void initState() {
    super.initState();
    //friendCount = 100;
    _loadApiService();
    postsCount = 100;
    _initStateAsync();
    // ここで必要な初期化を行う
  }

  Future<void> _initStateAsync() async {
    await _loadApiService();
    // initState 内で非同期処理を実行する場合、setState を呼ぶと再度 build メソッドが実行される
    setState(() {});
  }

  Future<void> _loadApiService() async {
    try {
      friendCount = await ApiService.fetchFriendsCount(userID);
    } catch (e) {
      print('フレンド数の取得に失敗しました: $e');
    }
  }

  void _showEnlargeDialog() {
    // 画像拡大ダイアログの表示ロジックを実装
    // ...

    // 例: ダイアログを表示する際に使用する関数
    showDialog<void>(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // タップでダイアログを閉じる
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 1.8,
                // 画像を表示するロジックをここに追加
                backgroundImage: decodedprofile != null
                    ? MemoryImage(decodedprofile!)
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ElevatedButton followButton = ElevatedButton(
      onPressed: () {
        setState(() {
          isFollowing = !isFollowing; // ボタンをクリックすると状態をトグル
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isFollowing
            ? const Color.fromARGB(255, 228, 255, 253)
            : const Color(0xFFf2fcfc), // フォロー中かどうかで色を変更
        elevation: 4, // 影の設定
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 四角い形状に設定
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 幅を80%に設定
        height: 50,
        child: Center(
          child: Text(
            isFollowing ? 'フレンド' : 'フレンドになる',
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
    //ThemeData selectedTheme = lightTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 前の画面に戻る
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0), // Adjust the value as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showEnlargeDialog();
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: decodedprofile != null
                            ? MemoryImage(decodedprofile!)
                            : null,
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          '投稿数',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$postsCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FriendList(userId: userID),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'フレンド数\n',
                                ),
                                TextSpan(
                                  text: '$friendCount',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userID,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                bio ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              followButton, // フォローボタンを追加
            ],
          ),
        ),
      ),
    );
  }
}
