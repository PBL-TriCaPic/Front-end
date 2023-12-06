// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/login/start.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';

import '../../main.dart';
import '../app.dart';
//import 'package:flutter_application_develop/main.dart';

class Item3Screen extends StatelessWidget {
  const Item3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログアウト'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // ログアウトボタンが押されたときの処理
                showLogoutConfirmationDialog(context);
              },
              child: Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ログアウトの確認'),
          content: Text('本当にログアウトしますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                // ログアウト処理
                logout(context, false);
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
              child: Text('ログアウト'),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(BuildContext context, bool isLoggedIn) async {
    // ログアウト処理
    await SharedPrefs.saveLoginStatus(context, isLoggedIn);
    final nextScreen = isLoggedIn ? const Start() : const AuthScreen();

    // ログアウト後に遷移する画面を指定（今回はログイン画面）
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ),
      (route) => false,
    );
  }
}
