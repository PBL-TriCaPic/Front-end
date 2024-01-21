// ignore_for_file: file_names, no_logic_in_create_state, avoid_print, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Friend/Friend_List.dart';

import '../theme_setting/HTTP_request.dart';
import '../theme_setting/SharedPreferences.dart';
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

  //bool isFollowing = false; // フォロー状態を管理する変数
  List<String> userIDs = []; // この行を追加
  String? myUserID; // myUserIDを追加
  int friendStatus = 0;

  MyHomePageState({
    required this.username,
    required this.userID,
  });

  @override
  void initState() {
    super.initState();
    _loadApiService();
    _initStateAsync();
    // ここで必要な初期化を行う
  }

  Future<void> _initStateAsync() async {
    await _loadApiService();
    // initState 内で非同期処理を実行する場合、setState を呼ぶと再度 build メソッドが実行される
    myUserID = await SharedPrefs.getUserId();
    int friendStatusget =
        await ApiService.fetchFriendsStatus(myUserID!, widget.userID);
    setState(() {
      friendStatus = friendStatusget; // 正しい初期化
    });
  }

  Future<void> _loadApiService() async {
    try {
      myUserID = await SharedPrefs.getUserId();
      // 2つの非同期処理を同時に実行
      final userDataFuture = ApiService.fetchUserData(userID);
      final friendStatusget =
          ApiService.fetchFriendsStatus(myUserID!, widget.userID);
      // それぞれの結果を待つ
      final userData = await userDataFuture;
      final FSG = await friendStatusget;

      // ユーザーのプロフィール画像データをデコード
      String? imageBase64 = userData['imageDataBase64'];
      if (imageBase64 != null) {
        decodedprofile = base64Decode(imageBase64);
      }

      postsCount = userData['capsulesCount'];
      bio = userData['profile'];
      friendCount = userData['friendsCount'];
      friendStatus = FSG;
    } catch (e) {
      print('データの取得に失敗しました: $e');
    }
  }

  Future<void> _reloadApiService() async {
    try {
      final count = await ApiService.fetchFriendsCount(userID);
      setState(() {
        friendCount = count;
      });
    } catch (e) {
      print('フレンド数の取得に失敗しました: $e');
    }
  }

  void _showEnlargeDialog() {
    // 画像拡大ダイアログの表示ロジックを実装
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
    Widget followButton = buildFriendButton(friendStatus);
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // 前の画面に戻る
          },
        ),
      ),
      body: FutureBuilder(
        future: _loadApiService(), // 非同期処理を返す関数を指定
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ローディング中の場合はインジケーターを表示
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // エラーが発生した場合はエラーメッセージを表示
            return Center(
              child: Text('データの取得に失敗しました: ${snapshot.error}'),
            );
          } else {
            // データの取得が成功した場合は画面を表示
            return SingleChildScrollView(
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
                                'カプセル数',
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
            );
          }
        },
      ),
    );
  }

  Widget buildFriendButton(int friendStatus) {
    if (friendStatus != null) {
      switch (friendStatus) {
        case 1:
          return buildUnfollowButton1();
        case 3:
          return buildUnfollowButton3();
        case 0:
          return buildFollowButton0();
        case 2:
          return buildFollowButton2();
        default:
          return const SizedBox.shrink(); // デフォルトの場合は空のWidgetを返す
      }
    } else {
      return const SizedBox.shrink(); // friendStatusがnullの場合も空のWidgetを返す
    }
  }

  Widget buildFollowButton2() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await ApiService.followUser(myUserID!, widget.userID);
          _reloadApiService();
          setState(() {
            friendStatus = 3;
          });
        } catch (e) {
          print('エラーが発生しました: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFf2fcfc), // フォローしていないときの色
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 四角い形状に設定
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 幅を80%に設定
        height: 50,
        child: const Center(
          child: Text(
            'リクエスト承認する',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }

  Widget buildFollowButton0() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await ApiService.followUser(myUserID!, widget.userID);
          _reloadApiService();
          setState(() {
            friendStatus = 1;
          });
        } catch (e) {
          print('エラーが発生しました: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFf2fcfc), // フォローしていないときの色
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 四角い形状に設定
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 幅を80%に設定
        height: 50,
        child: const Center(
          child: Text(
            'フォローする',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }

  Widget buildUnfollowButton3() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await ApiService.unfollowUser(myUserID!, widget.userID);
          _reloadApiService();
          setState(() {
            friendStatus = 2;
          });
        } catch (e) {
          print('エラーが発生しました: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 228, 255, 253), // フォロー中の色
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 四角い形状に設定
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 幅を80%に設定
        height: 50,
        child: const Center(
          child: Text(
            'フレンド',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }

  Widget buildUnfollowButton1() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await ApiService.unfollowUser(myUserID!, widget.userID);
          _reloadApiService();
          setState(() {
            friendStatus = 0;
          });
        } catch (e) {
          print('エラーが発生しました: $e');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 228, 255, 253), // フォロー中の色
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 四角い形状に設定
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // 幅を80%に設定
        height: 50,
        child: const Center(
          child: Text(
            'フレンドリクエスト中',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
