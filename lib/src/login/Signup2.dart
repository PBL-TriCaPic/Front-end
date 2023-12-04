import 'package:flutter/material.dart';
import '../login/HomeScreen2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../theme_setting/HTTP_request.dart';

//完了

class Signup2 extends StatefulWidget {
  @override
  _Signup2State createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final TextEditingController userIdController =
      TextEditingController(text: '@');
  final TextEditingController nameController = TextEditingController();
  String emailError = "";
  String passwordError = "";

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r"^[\w-+.!#$%&'*/=?^`{|}~]+@[\w-]+(\.[\w-]+)+$");
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final passwordRegExp = RegExp(r"^(?=.*[A-Z])[a-zA-Z0-9.?/-]{8,24}$");
    return passwordRegExp.hasMatch(password);
  }

  // Future<bool> createUser() async {
  //   final url = Uri.parse('http://192.168.10.119:8081/api/create/user');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = json.encode({
  //     'userId': userIdController.text,
  //     'email': emailController.text,
  //     'password': passwordController.text,
  //     'name': nameController.text,
  //   });

  //   final response = await http.post(url, headers: headers, body: body);

  //   if (response.statusCode == 200) {
  //     print('POSTリクエストが成功しました');
  //     print('サーバーレスポンス: ${response.body}'); // サーバーレスポンスをログに表示
  //     return response.body == 'true';
  //   } else {
  //     throw Exception('Failed to create user');
  //   }
  // }

  void handleclear() async {
    setState(() async {
      if (!isEmailValid(emailController.text)) {
        setState(() {
          emailError = "無効なメールアドレスです";
        });
      } else {
        setState(() {
          emailError = "";
        });
      }

      if (!isPasswordValid(passwordController.text)) {
        setState(() {
          passwordError = "大文字のアルファベットを少なくとも一つ含み、\n 8 文字以上 24 文字以下にしてください";
        });
      } else {
        setState(() {
          passwordError = "";
        });
      }
      String userID = userIdController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String rePassword = rePasswordController.text;
      String name = nameController.text;

      if (password == rePassword &&
          passwordError.isEmpty &&
          emailError.isEmpty) {
        await ApiService.createUser(userID, email, password, name)
            .then((success) {
          if (success) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeScreen2()),
            );
          } else {
            // ユーザーの作成に失敗した場合の処理をここに追加
            print('POSTリクエストが失敗しました');
          }
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('エラー'),
              content: Text('パスワードが一致しない、もしくはパスワードが適切ではありません。'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('閉じる'),
                ),
              ],
            );
          },
        );
      }
    });
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'username',
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: emailError.isNotEmpty ? emailError : null,
                ),
              ),
              SizedBox(height: 50.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password',
                  errorText: passwordError.isNotEmpty ? passwordError : null,
                ),
                onChanged: (value) {
                  setState(() {
                    // パスワードのバリデーションを呼び出す
                    isPasswordValid(value);
                  });
                },
              ),
              TextField(
                controller: rePasswordController,
                decoration: InputDecoration(
                  labelText: 're password',
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    handleclear();
                  },
                  child: Text('入力完了'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
