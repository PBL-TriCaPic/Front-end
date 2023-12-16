// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Friend/Friend_Profile.dart';
import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';

import '../Profile/Profile.dart';
import '../theme_setting/HTTP_request.dart';
import '../theme_setting/SharedPreferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// class FriendList extends StatelessWidget {
//   final String initialuserId;

//   const FriendList({Key? key, required this.initialuserId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const FriendListpage(userId:userId);
//   }
// }

class FriendList extends StatefulWidget {
  final String? userId;

  const FriendList({Key? key, required this.userId}) : super(key: key);

  @override
  State<FriendList> createState() => _FriendListpageState();
}

class _FriendListpageState extends State<FriendList> {
  late String userId;
  List<String> usernames = [];
  List<String> userIDs = [];

  @override
  void initState() {
    super.initState();
    userId = widget.userId!;
    _fetchFriendsList();
  }

  Future<void> _fetchFriendsList() async {
    try {
      // ここでfetchFriendsListを呼び出してデータを取得
      List friendsList = await ApiService.fetchFriendsList(userId);

      // データをusernamesとuserIDsにセット
      setState(() {
        usernames =
            friendsList.map((friend) => friend['name'] as String).toList();
        userIDs =
            friendsList.map((friend) => friend['userId'] as String).toList();
      });
    } catch (e) {
      // エラーハンドリング
      print('友達リストの取得に失敗しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フォロワー一覧'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 前の画面に戻る
          },
        ),
      ),
      body: ListView.builder(
        itemCount: usernames.length,
        itemBuilder: (context, index) {
          final username = usernames[index];
          final userID = userIDs[index];

          return ListTile(
            contentPadding: const EdgeInsets.only(left: 50.0),
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
      );
    } else {
      // 目的のユーザーIDが異なる場合、UserDetailsScreenに遷移
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserDetailsScreen(username: username, userID: userID),
        ),
      );
    }
  }
}
