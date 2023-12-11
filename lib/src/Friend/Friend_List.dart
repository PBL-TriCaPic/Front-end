// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Friend/Friend_Profile.dart';
import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class FriendList extends StatelessWidget {
  const FriendList({Key? key});

  @override
  Widget build(BuildContext context) {
    return const FriendListpage();
  }
}

class FriendListpage extends StatefulWidget {
  const FriendListpage({Key? key});

  @override
  State<FriendListpage> createState() => FriendListpageState();
}

class FriendListpageState extends State<FriendListpage> {
  final List<String> usernames = [
    'たくひろ',
    'まさと',
    'ドラゴン',
    'かわむら',
    'さいとう',
    '青池',
    'KAWAGUCHI',
    '武居',
    'Ito',
    '榊原',
    'よしなが',
    'としま'
  ]; // ユーザーネームのリスト
  final List<String> userIDs = [
    '@taku',
    '@masato',
    '@doragon',
    '@kawa',
    '@Saito',
    '@aoike',
    '@hiro',
    '@inori',
    '@itouuuuuuuuuuuuuuu',
    '@sakaki',
    '@naga',
    '@toshima'
  ]; // ユーザーIDのリスト

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
            contentPadding: const EdgeInsets.only(left: 16.0), // 左側のスペースを追加
            title: Text(username),
            subtitle: Text(userID),
            onTap: () {
              // タップされたときの画面遷移処理を実装
              _navigateToUserDetails(context, username, userID);
            },
          );
        },
      ),
    );
  }

  // タップされたときの画面遷移処理
  void _navigateToUserDetails(
      BuildContext context, String username, String userID) {
    // ここに画面遷移の処理を実装
    // 例えば、ユーザー詳細画面に遷移する場合：
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserDetailsScreen(username: username, userID: userID),
      ),
    );
  }
}
