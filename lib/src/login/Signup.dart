import 'package:flutter/material.dart';
import 'package:flutter_application_develop/main.dart';
import '../login/Signup2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String emailError = "";

  TextEditingController emailController = TextEditingController();

  // メールアドレスのバリデーションルール
  bool isEmailValid(String email) {
    // ここでバリデーションルールを定義します。正規表現を使用するのが一般的です。
    final emailRegExp = RegExp(r"^[\w-+.!#$%&'*/=?^`{|}~]+@[\w-]+(\.[\w-]+)+$");
    return emailRegExp.hasMatch(email);
  }

  // ログインボタンが押された時の処理
  Future<void> handleLogin() async {
    String email = emailController.text; // メールアドレスを取得

    if (!isEmailValid(email)) {
      setState(() {
        emailError = "無効なメールアドレスです";
      });
    } else {
      // メールアドレスが有効な場合、次の画面に遷移します（'NextScreen' は目的の画面のクラスに置き換えてください）。
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Signup2()), // お好きな画面に置き換えてください。
      );
      setState(() {
        emailError = "";
      });

      try {
        // サーバーにメールアドレスを送信
        final response = await server(email);
        // レスポンスの処理
      } catch (e) {
        // エラーハンドリング: リクエストが失敗した場合
        print("Failed to send email to server: $e");
      }
    }
  }

  // サーバーにメールアドレスを送信
  Future<Map<String, dynamic>> server(String email) async {
    final url = Uri.parse('http://10.0.2.2:8081/api/login');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      "email": email,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // リクエストが成功し、サーバーからJSON応答が返された場合
      return json.decode(response.body);
    } else {
      // リクエストが失敗した場合
      throw Exception('Failed to login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サインアップ'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'e-mail',
                errorText:
                    emailError.isNotEmpty ? emailError : null, // エラーメッセージを表示
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    },
                    child: Text('戻る'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      handleLogin();
                    },
                    child: Text('入力完了'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
