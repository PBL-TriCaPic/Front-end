// import 'package:flutter_application_develop/src/Map/Map.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter/material.dart';
// import '../app.dart';
// import 'Login.dart';
// import 'Signup2.dart';
// //import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'homescreen.dart';

// class AuthProvider extends ChangeNotifier {
//   bool isAuthenticated = false;

//   void setAuthenticated(bool value) {
//     isAuthenticated = value;
//     notifyListeners();
//   }

//   Future<void> checkAuthentication() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool authenticated = prefs.getBool('authenticated') ?? false;
//     setAuthenticated(authenticated);
//   }

//   Future<void> login() async {
//     // ログインのロジックを実行
//     // ...

//     // 認証ステータスを true に設定
//     setAuthenticated(true);

//     // 認証ステータスを保存
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('authenticated', true);
//   }

//   // ログアウトメソッド
//   Future<void> logout() async {
//     isAuthenticated = false;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('authenticated'); // 認証ステータスを削除
//     notifyListeners();
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FutureBuilder(
//         // checkAuthentication メソッドの実行結果を待つ
//         future: Provider.of<AuthProvider>(context, listen: false)
//             .checkAuthentication(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // ログイン状態に応じて画面を切り替え
//             return Consumer<AuthProvider>(
//               builder: (context, authProvider, _) {
//                 return authProvider.isAuthenticated
//                     ? MyStatefulWidget()
//                     : Start();
//               },
//             );
//           } else {
//             // 非同期処理が完了するまでローディング画面を表示
//             return Scaffold(
//               body: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class Start extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TriCaPic'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(100.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => Login()),
//                   );
//                 },
//                 child: Text('Login'),
//               ),
//             ),
//             SizedBox(height: 50.0),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => Signup2()),
//                   );
//                 },
//                 child: Text('Signup'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'homescreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    // ここで非同期の認証チェックを行うロジックを実装

    // 例: シンプルなタイマーで非同期処理を模倣
    await Future.delayed(Duration(seconds: 2));

    // ダミーの認証結果
    bool authenticated = false; // ロジックに基づいて認証結果をセット

    setState(() {
      isAuthenticated = authenticated;
    });
  }

  void login() {
    // ログインのロジックを実行

    // 例: シンプルなタイマーで非同期処理を模倣
    Future.delayed(Duration(seconds: 2), () {
      // ログイン成功時の処理
      setState(() {
        isAuthenticated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TriCaPic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  // ここにサインアップの画面遷移などの処理を追加
                },
                child: Text('Signup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthScreen(),
    );
  }
}
