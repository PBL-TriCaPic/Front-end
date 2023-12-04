// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Start extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }

//   void checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//     // ログイン状態に応じて画面を切り替え
//     Navigator.of(context as BuildContext).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => isLoggedIn ? HomeScreen() : LoginScreen(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // ログインボタンが押されたときの処理
//             saveLoginStatus(true);
//           },
//           child: Text('Log In'),
//         ),
//       ),
//     );
//   }

//   void saveLoginStatus(bool isLoggedIn) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isLoggedIn', isLoggedIn);
//     // ログイン後に遷移する画面を指定
//     Navigator.of(context as BuildContext).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => HomeScreen(),
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Text('Welcome!'),
//       ),
//     );
//   }
// }
