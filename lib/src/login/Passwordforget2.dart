// import 'package:flutter/material.dart';
// import 'package:flutter_application_develop/src/app.dart';
// import '../login/HomeScreen2.dart';

// class Signup2 extends StatefulWidget {
//   @override
//   _Signup2State createState() => _Signup2State();
// }

// class _Signup2State extends State<Signup2> {
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController rePasswordController = TextEditingController();
//   String password = "";
//   String passwordError = "";

//   bool isPasswordValid(String password) {
//     final passwordRegExp = RegExp(r"^(?=.*[A-Z])[a-zA-Z0-9.?/-]{8,24}$");
//     return passwordRegExp.hasMatch(password);
//   }

//   // 入力完了ボタンが押された時の処理
//   void handleclear() {
//     setState(() {
//       if (!isPasswordValid(password)) {
//         passwordError = "大文字のアルファベットを少なくとも一つ含み、\n 8 文字以上 24 文字以下にしてください";
//       } else {
//         passwordError = "";
//       }

//       String password1 = passwordController.text;
//       String rePassword = rePasswordController.text;

//       if (password1 == rePassword && passwordError.isEmpty) {
//         // パスワードと再確認パスワードが一致し、かつ passwordError が空の場合、ログイン処理を実行
//         // ここにログイン処理のコードを追加
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => Start()),
//         );
//       } else {
//         // パスワードが一致しないか、パスワードエラーがある場合、ユーザに通知するなどの処理を追加
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text('エラー'),
//               content: Text('パスワードが一致しない、もしくはパスワードが適切ではありません。'),
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
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('パスワード再設定'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 50.0),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'password',
//                   errorText: passwordError.isNotEmpty ? passwordError : null,
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     password = value;
//                     // パスワードのバリデーションを呼び出す
//                     isPasswordValid(password);
//                   });
//                 },
//               ),
//               TextField(
//                 controller: rePasswordController,
//                 decoration: InputDecoration(
//                   labelText: 're password',
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     handleclear();
//                   },
//                   child: Text('入力完了'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
