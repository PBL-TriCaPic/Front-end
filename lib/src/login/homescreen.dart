// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/main.dart';

// class MapScreen extends StatelessWidget {
//   final String userId;
//   final String username;
//   final List<int> capsulesIdList;
//   final List<double> capsuleLatList;
//   final List<double> capsuleLonList;

//   const MapScreen({
//     Key? key,
//     required this.userId,
//     required this.username,
//     required this.capsulesIdList,
//     required this.capsuleLatList,
//     required this.capsuleLonList,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: HomeScreen(
//         title: 'Flutter Demo Home Page',
//         userId: userId,
//         username: username,
//         capsulesIdList: capsulesIdList,
//         capsuleLatList: capsuleLatList,
//         capsuleLonList: capsuleLonList,
//       ),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   final String title;
//   final String userId;
//   final String username;
//   final List<int> capsulesIdList;
//   final List<double> capsuleLatList;
//   final List<double> capsuleLonList;

//   const HomeScreen({
//     Key? key,
//     required this.title,
//     required this.userId,
//     required this.username,
//     required this.capsulesIdList,
//     required this.capsuleLatList,
//     required this.capsuleLonList,
//   }) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreen();
// }

// class _HomeScreen extends State<HomeScreen> {
//   List<int> capsulesIdList = [];
//   List<double> capsuleLatList = [];
//   List<double> capsuleLonList = [];

//   void handleLogout() {
//     // AuthProviderのインスタンスを取得
//     AuthProvider authProvider =
//         Provider.of<AuthProvider>(context, listen: false);

//     // ログアウトメソッドを呼び出す
//     authProvider.logout();

//     // ログアウト後の画面に遷移する等の処理をここに追加
//     // 例: ログイン画面に遷移
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => start()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print('UserId: ${widget.userId}');
//     // print('Username: ${widget.username}');
//     // print("カプセルIDリスト: ${widget.capsulesIdList.join(', ')}");
//     // print("カプセル緯度リスト: ${widget.capsuleLatList.join(', ')}");
//     // print("カプセル経度リスト: ${widget.capsuleLonList.join(', ')}");

//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Image.asset(
//             'asset/img/TriCaPiclogo.png',
//             height: 200,
//             width: 200,
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: () {
//                 handleLogout();
//               }, // ログアウトコールバックを呼び出す
//             ),
//           ],
//           elevation: 3,
//           shadowColor: Colors.black,
//         ),
//         body: Column(
//           children: [
//             const Center(
//                 child: Text('Map画面', style: TextStyle(fontSize: 32.0))),
//             Text('UserId: ${widget.userId}'),
//             Text('Username: ${widget.username}'),
//             Text("カプセルIDリスト: ${widget.capsulesIdList.join(', ')}"),
//             Text("カプセル緯度リスト: ${widget.capsuleLatList.join(', ')}"),
//             Text("カプセル経度リスト: ${widget.capsuleLonList.join(', ')}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
