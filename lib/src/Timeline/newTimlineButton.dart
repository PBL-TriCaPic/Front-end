// ignore_for_file: file_names
// // ignore_for_file: file_names, use_build_context_synchronously, unnecessary_string_interpolations

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import '../Capsule_open/Capcontents.dart';

// class CityButtonsWidget extends StatelessWidget {
//   final List<String> cityNames;
//   final List<String> userNames;
//   final List<String> userIds;
//   final List<int> capsuleId;
//   final List<double> capsuleLatList;
//   final List<double> capsuleLonList;

//   const CityButtonsWidget({
//     super.key,
//     required this.cityNames,
//     required this.userNames,
//     required this.userIds,
//     required this.capsuleId,
//     required this.capsuleLatList,
//     required this.capsuleLonList,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context)
//           .size
//           .height, //screenHeightWithoutNavBars, // 適切な高さを指定
//       width: MediaQuery.of(context).size.width, //widgetWidth,
//       child: GridView.builder(
//         shrinkWrap: false, // グリッドの高さに合わせてシュリンク
//         padding: EdgeInsets.zero, // 余白をゼロにするか確認
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // 列数を指定
//           crossAxisSpacing: 20.0, // 列間のスペース
//           mainAxisSpacing: 20.0, // 行間のスペース
//         ),
//         itemCount: cityNames.length,
//         itemBuilder: (context, index) {
//           return _buildCityButton(context, index);
//         },
//       ),
//     );
//   }

//   Widget _buildCityButton(BuildContext context, int index) {
//     //final int currentCapsuleId = timelinePageState.getCapsulesIdList()[index];
//     return ElevatedButton(
//       onPressed: () async {
//         // 位置情報を取得
//         Position currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best,
//         );
//         double targetLatitude = capsuleLatList[index];
//         double targetLongitude = capsuleLonList[index];

//         // ボタンの位置と現在位置との距離を計測
//         double distanceInMeters = Geolocator.distanceBetween(
//           currentPosition.latitude,
//           currentPosition.longitude,
//           targetLatitude, // ボタンの緯度
//           targetLongitude, // ボタンの経度
//         );

//         // 距離が500メートル以内なら通常の画面表示
//         if (distanceInMeters <= 500) {
//           //print('Selected Capsule ID: ${capsuleId[index]}');
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CapContentsScreen(
//                 capsuleId: capsuleId[index].toString(),
//                 cityName: cityNames[index],
//               ),
//             ),
//           );
//         } else {
//           // 500メートル以上ならダイアログ表示
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('注意'),
//                 content: const Text('ボタンが500メートル以上離れています。'),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.all(16),
//         minimumSize: const Size(100, 100),
//         shape: const CircleBorder(),
//         elevation: 10,
//         //primary: Colors.transparent, // 背景色を透明に設定
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               'assets/TimeCapsule.PNG',
//             ), // 画像のパス
//             fit: BoxFit.cover, // 画像をボタンにフィットさせるかどうか
//           ),
//         ),
//         width: 250, // 任意の幅を指定
//         height: 250, // 任意の高さを指定
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // 垂直方向に中央寄せ
//           children: [
//             Text(
//               '${userNames[index]}',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
//             ),
//             Text(
//               '${userIds[index]}',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 15, fontWeight: FontWeight.bold), // テキストサイズを指定
//             ),
//             Text(
//               '${cityNames[index]}',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
