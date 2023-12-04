import 'package:flutter_application_develop/src/Map/Map.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/login/Login.dart';
import 'src/login/Signup2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/login/homescreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;

  void setAuthenticated(bool value) {
    isAuthenticated = value;
    notifyListeners();
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authenticated = prefs.getBool('authenticated') ?? false;
    setAuthenticated(authenticated);
  }

  Future<void> login() async {
    // ログインのロジックを実行
    // ...

    // 認証ステータスを true に設定
    setAuthenticated(true);

    // 認証ステータスを保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('authenticated', true);
  }

  // ログアウトメソッド
  Future<void> logout() async {
    isAuthenticated = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authenticated'); // 認証ステータスを削除
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          authProvider.checkAuthentication();
          return authProvider.isAuthenticated
              ? MyStatefulWidget()
              : Start(); //現状、MyStatefulWidget()にできない。ここのMyStatefulWidget()をMapScreen()に変えるとマップの画面だけなら表示可能
        },
      ),
    );
  }
}

class Start extends StatelessWidget {
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Signup2()),
                  );
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
