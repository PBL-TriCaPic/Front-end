// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:flutter_application_develop/src/login/start.dart';
import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_application_develop/main.dart';
// import '../login/homescreen.dart';

import '../theme_setting/HTTP_request.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String emailError = "";
  String passwordError = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String responseMessage = "";
  List<int> capsulesIdList = [];
  List<double> capsuleLatList = [];
  List<double> capsuleLonList = [];

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r"^[\w-+.!#$%&'*/=?^`{|}~]+@[\w-]+(\.[\w-]+)+$");
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final passwordRegExp = RegExp(r"^(?=.*[A-Z])[a-zA-Z0-9.?/-]{8,24}$");
    return passwordRegExp.hasMatch(password);
  }

  // Future<void> authenticateUsers() async {
  //   final email = emailController.text;
  //   final password = passwordController.text;

  //   final response = await http.post(
  //     Uri.parse('http://10.0.2.2:8081/api/login'), // バックエンドのエンドポイント
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'email': email, 'password': password}),
  //   );

  //   if (response.statusCode == 200) {
  //     final userData = jsonDecode(response.body);
  //     // ユーザーセッション情報を保存
  //     // 通常はセキュアな保存方法を使用してください
  //     // 例: Flutter Secure Storage パッケージを使用
  //     // https://pub.dev/packages/flutter_secure_storage
  //     // この例では単純にメモリに保存します
  //     // SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // await prefs.setString('userId', userData['userId']);
  //     // await prefs.setString('username', userData['username']);
  //     // await prefs.setString('capsulesIdList', userData['capsulesIdList']);
  //     // await prefs.setString('capsuleLatList', userData['capsuleLatList']);
  //     // await prefs.setString('capsuleLonList', userData['capsuleLonList']);

  //     //Provider.of<AuthProvider>(context, listen: false)
  //     //.login(); // login メソッドを呼び出し

  //     setState(() {
  //       responseMessage =
  //           "UserID: ${userData['userId']}, Username: ${userData['username']}";
  //     });

  //     // ignore: use_build_context_synchronously
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => MapScreen(),
  //       ),
  //     );
  //   } else {
  //     // setState(() {
  //     //   message = 'Login failed. Please check your credentials.';
  //     // });
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('エラー'),
  //           content: Text('ログインに失敗しました\nメールアドレス、もしくはパスワードが間違っています'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('閉じる'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  Future<void> handleLogin(BuildContext context, bool isLoggedIn) async {
    final email = emailController.text;
    final password = passwordController.text;
    if (!isEmailValid(email)) {
      setState(() {
        emailError = "無効なメールアドレスです";
      });
    } else {
      setState(() {
        emailError = "";
      });

      if (!isPasswordValid(password)) {
        setState(() {
          passwordError = "大文字のアルファベットを少なくとも一つ含み、\n 8 文字以上 24 文字以下にしてください";
        });
      } else {
        setState(() {
          passwordError = "";
        });
      }

      if (isEmailValid(email) && isPasswordValid(password)) {
        try {
          final success = await ApiService.loginUser(email, password);

          // サーバーからユーザー情報を取得
          await SharedPrefs.setEmail(email);
          await SharedPrefs.setPassword(password);
          await SharedPrefs.setUsername(success['username']);
          await SharedPrefs.setUserId(success['userId']);
          final List<int> capsulesIdList =
              List<int>.from(success['capsulesIdList'] ?? []);
          final List<double> capsulesLatList =
              List<double>.from(success['capsuleLatList'] ?? []);
          final List<double> capsulesLonList =
              List<double>.from(success['capsuleLonList'] ?? []);
          await SharedPrefs.setCapsulesCount(capsulesIdList.length);
          await SharedPrefs.setCapsulesIdList(capsulesIdList);
          await SharedPrefs.setCapsulesLatList(capsulesLatList);
          await SharedPrefs.setCapsulesLonList(capsulesLonList);
          await SharedPrefs.saveLoginStatus(context, isLoggedIn);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Start(),
            ),
          );
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('エラー'),
                content: const Text('ログインに失敗しました\nメールアドレス、もしくはパスワードが間違っています'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('閉じる'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('エラー'),
              content: const Text('正しい形式で入力してください'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('閉じる'),
                ),
              ],
            );
          },
        );
      }
    }
  }
  //        catch (e) {
  //         showDialog(
  //           context: context,
  //           builder: (context) {
  //             return AlertDialog(
  //               title: Text('エラー'),
  //               content: Text('例外のエラーが発生しました。'),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('閉じる'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     }
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getUsers() async {
  //   final url =
  //       Uri.parse('http://10.0.2.2:8081/api/get/users'); // ユーザー情報を取得するエンドポイント
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> userList = json.decode(response.body);
  //     return userList.cast<Map<String, dynamic>>();
  //   } else {
  //     throw Exception('Failed to get users');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = lightTheme;
    return MaterialApp(
      theme: selectedTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ログイン'),
          automaticallyImplyLeading: false,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'e-mail',
                  errorText: emailError.isNotEmpty ? emailError : null,
                ),
                onChanged: (value) {
                  setState(() {
                    emailController.text = value;
                    isEmailValid(emailController.text);
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'password',
                  errorText: passwordError.isNotEmpty ? passwordError : null,
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    passwordController.text = value;
                    isPasswordValid(passwordController.text);
                  });
                },
              ),
              // Container(
              //   margin: EdgeInsets.all(8.0),
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: Colors.black,
              //       width: 2.0,
              //     ),
              //     borderRadius: BorderRadius.circular(8.0),
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (context) => Passwordforget()),
              //       );
              //     },
              //     child: Text('パスワードを忘れた人'),
              //   ),
              // ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AuthScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5, // 影の設定
                      ),
                      child: const Text(
                        '戻る',
                        style: TextStyle(
                          fontSize: 18, // フォントサイズの設定
                          fontWeight: FontWeight.bold, // 太文字の設定
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: ElevatedButton(
                      onPressed: () {
                        handleLogin(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5, // 影の設定
                      ),
                      child: const Text(
                        'ログイン',
                        style: TextStyle(
                          fontSize: 18, // フォントサイズの設定
                          fontWeight: FontWeight.bold, // 太文字の設定
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
