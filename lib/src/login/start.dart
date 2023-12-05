import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/login/Login.dart';
import 'package:flutter_application_develop/src/login/Signup2.dart';
import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';
import 'homescreen.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = lightTheme;
    return MaterialApp(
      theme: selectedTheme,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/TriCaPic_logo.png',
            height: 200,
            width: 200,
          ),
          elevation: 3,
          shadowColor: Colors.black,
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
                      MaterialPageRoute(builder: (context) => LoginApp()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5, // 影の設定
                  ),
                  child: Text(
                    'ログイン',
                    style: TextStyle(
                      fontSize: 18, // フォントサイズの設定
                      fontWeight: FontWeight.bold, // 太文字の設定
                    ),
                  ),
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
                  style: ElevatedButton.styleFrom(
                    elevation: 5, // 影の設定
                  ),
                  child: Text(
                    'アカウント作成',
                    style: TextStyle(
                      fontSize: 18, // フォントサイズの設定
                      fontWeight: FontWeight.bold, // 太文字の設定
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AuthScreen(),
//     );
//   }
// }
