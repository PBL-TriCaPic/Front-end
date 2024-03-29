// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously, avoid_unnecessary_containers, void_checks, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Follow_map.dart';
import 'package:flutter_application_develop/src/Map/My_map.dart';

import '../theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);


class MapScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const MapScreen({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              'assets/TriCaPic_logo.png',
              height: 200,
              width: 200,
            ),
            elevation: 3,
            shadowColor: Colors.black,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.map),
                  text: '私の地図',
                ),
                Tab(icon: Icon(Icons.map_outlined), text: 'フレンドの地図'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyHomeScreen(title: '',),
              FollowHomeScreen(title: '',),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_develop/src/Map/Capsel/picture.dart';
// import 'package:flutter_application_develop/src/Map/Follow_map.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:latlong2/latlong.dart';

// import '../theme_setting/Color_Scheme.dart';
// import '../theme_setting/SharedPreferences.dart';

// final ThemeData lightTheme =
//     ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// class MapScreen extends StatelessWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       //theme: themeProvider.selectedTheme,
//       theme: lightTheme,
//       // darkTheme: darkTheme,
//       title: 'Flutter Demo',
//       home: const HomeScreen(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key, required this.title});

//   final String title;

//   @override
//   State<HomeScreen> createState() => _HomeScreen();
// }

// class _HomeScreen extends State<HomeScreen> {
//   //String _title = 'MyMap';
//   double? lat; //メモ：最初に表示される場所を指定
//   double? lng;
//   LatLng? tapLatLng; //メモ：?はnullも許容
//   //画像保存用のpreference
//   //late SharedPreferences pref;
//   late XFile image;

//   File? imageFile;
//   List<Marker> markers = [];
//   List<CircleMarker> circleMarkers = []; //中身ないけど、削除すると現在地の●表示されなくなる
//   bool isLoading = true; // 追加: ローディング状態を管理



//   @override
//   void initState() {
//     super.initState();
//     initLocation();
//     loadSavedCapsules(); // Load saved capsules on initialization
   
   
//   }

//   Future<void> loadSavedCapsules() async {
//     //バックから緯度経度をとる
//     List<double> latList = await SharedPrefs.getCapsulesLatList();
//     List<double> lonList = await SharedPrefs.getCapsulesLonList();

//     for (int i = 0; i < min(latList.length, lonList.length); i++) {
//       LatLng capsuleLatLng = LatLng(latList[i], lonList[i]);
//       createPinFromSavedCapsule(capsuleLatLng);
//     }
//   }

//   void createPinFromSavedCapsule(LatLng capsuleLatLng) {
//     Marker marker = Marker(
//       point: capsuleLatLng,
//       width: 80,
//       height: 80,
//       builder: (context) => Container(
//         child: IconButton(
//           icon: const Icon(
//             Icons.location_on,
//             size: 40,
//             color: Colors.blue, // You can set your preferred color
//           ),
//           onPressed: () {
//             // Handle tap on saved capsule pin if needed
//           },
//         ),
//       ),
//     );
//     markers.add(marker);
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //カメラ表示追記1行
//     final ImagePicker _picker = ImagePicker();
//     ThemeData selectedTheme = lightTheme;
//     // 追加: isLoadingがtrueの場合はローディング表示
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return MaterialApp(
//       theme: selectedTheme,
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Image.asset(
//             'assets/TriCaPic_logo.png',
//             height: 200,
//             width: 200,
//           ),
//           elevation: 3,
//           shadowColor: Colors.black,

//           //ボタンの動きを追加Follow_mapへ
//            actions: [
//             // Wrap the IconButton with GestureDetector
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FollowMapScreen(),
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Icon(Icons.people_alt_outlined),
//               ),
//             ),
//           ],
          
//         ),
//         body: Container(
//           child: FlutterMap(
//             // マップ表示設定
//             options: MapOptions(
//               center: LatLng(lat!, lng!), //メモ:ここを変える
//               zoom: 15.0,
//               interactiveFlags: InteractiveFlag.all,
//               enableScrollWheel: true,
//               scrollWheelVelocity: 0.00001,
//               // onTap: (tapPosition, latLng) {
//               //   tapLatLng = latLng;
//               //   print(tapLatLng);
//               //   print("↑ピンを押したところの緯度経度");
//               //   cleatePin(tapLatLng!);
//               // },
//             ),
//             layers: [
//               //背景地図読み込み (OSM)
//               TileLayerOptions(
//                 urlTemplate: "https://tile.openstreetmap.jp/{z}/{x}/{y}.png",
//               ),
//               // サークルマーカー設定
//               CircleLayerOptions(
//                 circles: circleMarkers,
//               ),
//               // ピンマーカー設定
//               MarkerLayerOptions(
//                 markers: markers,
//               ),
//             ],
//           ),
//         ),

//         //右下のボタンの処理
//         floatingActionButton: FloatingActionButton(
//           //Iconの部分を書き換えるとアイコンのデザイン変更可
//           child: SvgPicture.asset(
//             'assets/TriCaPicapplogo1.svg',
//             width: 35,
//             height: 35,
//             color: Color.fromARGB(255, 224, 224, 224), // カスタムアイコンの色を指定
//           ),
//           onPressed: () async {
//             //カメラ撮影画面に遷移
//             final XFile? image = await _picker.pickImage(
//               source: ImageSource.camera,
//             );
//             if (image != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PictureCheck(image),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   //ピンを作成する
//   void cleatePin(LatLng tapLatLng) {
//     Marker marker = Marker(
//       point: tapLatLng,
//       width: 80,
//       height: 80,
//       builder: (context) => Container(
//         child: IconButton(
//           icon: const Icon(
//             Icons.location_on,
//             size: 40,
//             color: Colors.red,
//           ),
//           onPressed: () {
//             onTapPinCallBack(tapLatLng);
//           },
//         ),
//       ),
//     );
//     //BottomNavigatorを押しまくった時に、エラーが出るのを防いでくれるかもしれない記述
//     markers.add(marker);
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void onTapPinCallBack(LatLng latLng) {
//     final tapMarker = pinReturn(latLng, pinReturn);
//     markers.add(tapMarker);
//     markers.removeAt(1);
//     print('Pinをタップしたよ');
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Marker pinReturn(LatLng tapLatLng, void tapPin) {
//     return Marker(
//       point: tapLatLng,
//       width: 80,
//       height: 80,
//       builder: (context) => Container(
//         child: IconButton(
//           icon: const Icon(
//             Icons.location_on,
//             size: 20,
//             color: Colors.red,
//           ),
//           onPressed: () {
//             pinReturn(tapLatLng, tapPin);
//           },
//         ),
//       ),
//     );
//   }

//   //この関数の戻り値でlatitudeとlongtitudeの値(端末の現在地)
//   Future<void> initLocation() async {
//     //メモ：多分位置を取得するのを許可している？
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
// //メモ：Geo~.get~で現在地の位置情報取得し、currentPositionに代入
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // double latitude = position.latitude; //メモ：現在地読み込み？
//     // double longitude = position.longitude;
//     // //取得した緯度経度からその地点の地名情報を取得する
//     // final placeMarks = await geoCoding.placemarkFromCoordinates(lat!, lng!);
//     // final placeMark = placeMarks[0];
//     // print("現在地の国は、${placeMark.country}");
//     // print("現在地の県は、${placeMark.administrativeArea}");
//     // print("現在地の市は、${placeMark.locality}");
//     setState(() {
//       lat = position.latitude;
//       lng = position.longitude;
//       isLoading = false; // 追加: ローディング終了
//     });

//     initCircleMarker(lat!, lng!);
//   }

// //メモ：端末の現在地を青色の●で表示する関数
//   void initCircleMarker(double latitude, double longitude) {
//     CircleMarker circleMarker = CircleMarker(
//       color: Colors.indigo.withOpacity(0.9),
//       radius: 10,
//       borderColor: Colors.white.withOpacity(0.9),
//       borderStrokeWidth: 3,
//       point: LatLng(latitude, longitude),
//     );
//     print('initCircleMarkerはアプリ起動時に動く関数');
//     //print('lat1は${lat}lng1は${lng}');
//     //メモ：多分↓の行がないと●表示されない
//     circleMarkers.add(circleMarker);
//   }

//   void pinSizeChange() {}
// }



// final ThemeData lightTheme =
//     ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// class MapScreen extends StatelessWidget {
//   // ignore: use_super_parameters
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       //theme: themeProvider.selectedTheme,
//       theme: lightTheme,
//       // darkTheme: darkTheme,
//       title: 'Flutter Demo',
//       home: const HomeScreen(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key, required this.title});

//   final String title;

//   @override
//   State<HomeScreen> createState() => _HomeScreen();
// }

// class _HomeScreen extends State<HomeScreen> {
//   //String _title = 'MyMap';
//   double? lat; //メモ：最初に表示される場所を指定
//   double? lng;
//   LatLng? tapLatLng; //メモ：?はnullも許容
//   //画像保存用のpreference
//   //late SharedPreferences pref;
//   late XFile image;
//   late Timer locationUpdateTimer;

//   File? imageFile;
//   List<Marker> markers = [];
//   List<CircleMarker> circleMarkers = []; //中身ないけど、削除すると現在地の●表示されなくなる
//   bool isLoading = true; // 追加: ローディング状態を管理



//   @override
//   void initState() {
//     super.initState();
//     initLocation();
//     loadSavedCapsules(); // Load saved capsules on initialization
//     //他の人のピン表示
   
//     //loadSavedCapsules(); // Load saved capsules on initialization
//     startLocationUpdateTimer();
//   }

//   void startLocationUpdateTimer() {
//     locationUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       updateLocation();
//     });
//   }

//   Future<void> updateLocation() async {
//     // ここで位置情報を取得して更新する
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     setState(() {
//       lat = position.latitude;
//       lng = position.longitude;
//       // 新しい位置情報で円マーカーを更新
//       updateCircleMarker(lat!, lng!);
//     });
//   }

//   void updateCircleMarker(double latitude, double longitude) {
//     // 既存の円マーカーを新しい位置情報で更新
//     CircleMarker circleMarker = CircleMarker(
//       color: Colors.indigo.withOpacity(0.9),
//       radius: 10,
//       borderColor: Colors.white.withOpacity(0.9),
//       borderStrokeWidth: 3,
//       point: LatLng(latitude, longitude),
//     );

//     // 既存の円マーカーをクリアして新しいものを追加
//     circleMarkers.clear();
//     circleMarkers.add(circleMarker);
//   }

//   @override
//   void dispose() {
//     // タイマーをキャンセルする
//     locationUpdateTimer.cancel();
//     super.dispose();
//   }

//   Future<void> loadSavedCapsules() async {
//     //バックから緯度経度をとる
//     List<double> latList = await SharedPrefs.getCapsulesLatList();
//     List<double> lonList = await SharedPrefs.getCapsulesLonList();

//     for (int i = 0; i < min(latList.length, lonList.length); i++) {
//       LatLng capsuleLatLng = LatLng(latList[i], lonList[i]);
//       createPinFromSavedCapsule(capsuleLatLng);
//     }
//   }

//   void createPinFromSavedCapsule(LatLng capsuleLatLng) {
//     Marker marker = Marker(
//       point: capsuleLatLng,
//       width: 80,
//       height: 80,
//       builder: (context) => IconButton(
//         icon: const Icon(
//           Icons.location_on,
//           size: 40,
//           color: Colors.blue, // You can set your preferred color
//         ),
//         onPressed: () {
//           // Handle tap on saved capsule pin if needed
//         },
//       ),
//     );
//     markers.add(marker);
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //カメラ表示追記1行
//     final ImagePicker picker = ImagePicker();
//     ThemeData selectedTheme = lightTheme;
//     // 追加: isLoadingがtrueの場合はローディング表示
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return MaterialApp(
//       theme: selectedTheme,
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Image.asset(
//             'assets/TriCaPic_logo.png',
//             height: 200,
//             width: 200,
//           ),
//           elevation: 3,
//           shadowColor: Colors.black,

//           //ボタンの動きを追加Follow_mapへ
//            actions: [
//             // Wrap the IconButton with GestureDetector
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FollowMapScreen(),
//                   ),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Icon(Icons.people_alt_outlined),
//               ),
//             ),
//           ],
          
//         ),
//         body: FlutterMap(
//           // マップ表示設定
//           options: MapOptions(
//             center: LatLng(lat!, lng!), //メモ:ここを変える
//             zoom: 15.0,
//             interactiveFlags: InteractiveFlag.all,
//             enableScrollWheel: true,
//             scrollWheelVelocity: 0.00001,
//             // onTap: (tapPosition, latLng) {
//             //   tapLatLng = latLng;
//             //   print(tapLatLng);
//             //   print("↑ピンを押したところの緯度経度");
//             //   cleatePin(tapLatLng!);
//             // },
//           ),
//           layers: [
//             //背景地図読み込み (OSM)
//             TileLayerOptions(
//               urlTemplate: "https://tile.openstreetmap.jp/{z}/{x}/{y}.png",
//             ),
//             // サークルマーカー設定
//             CircleLayerOptions(
//               circles: circleMarkers,
//             ),
//             // ピンマーカー設定
//             MarkerLayerOptions(
//               markers: markers,
//             ),
//           ],
//         ),

//         //右下のボタンの処理
//         floatingActionButton: FloatingActionButton(
//           //Iconの部分を書き換えるとアイコンのデザイン変更可
//           child: SvgPicture.asset(
//             'assets/TriCaPicapplogo1.svg',
//             width: 35,
//             height: 35,
//             color: const Color.fromARGB(255, 224, 224, 224), // カスタムアイコンの色を指定
//           ),
//           onPressed: () async {
//             //カメラ撮影画面に遷移
//             final XFile? image = await picker.pickImage(
//               source: ImageSource.camera,
//             );
//             if (image != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PictureCheck(image),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   //ピンを作成する
//   void cleatePin(LatLng tapLatLng) {
//     Marker marker = Marker(
//       point: tapLatLng,
//       width: 80,
//       height: 80,
//       builder: (context) => Container(
//         child: IconButton(
//           icon: const Icon(
//             Icons.location_on,
//             size: 40,
//             color: Colors.red,
//           ),
//           onPressed: () {
//             onTapPinCallBack(tapLatLng);
//           },
//         ),
//       ),
//     );
//     //BottomNavigatorを押しまくった時に、エラーが出るのを防いでくれるかもしれない記述
//     markers.add(marker);
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void onTapPinCallBack(LatLng latLng) {
//     final tapMarker = pinReturn(latLng, pinReturn);
//     markers.add(tapMarker);
//     markers.removeAt(1);
//     print('Pinをタップしたよ');
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Marker pinReturn(LatLng tapLatLng, void tapPin) {
//     return Marker(
//       point: tapLatLng,
//       width: 80,
//       height: 80,
//       builder: (context) => Container(
//         child: IconButton(
//           icon: const Icon(
//             Icons.location_on,
//             size: 20,
//             color: Colors.red,
//           ),
//           onPressed: () {
//             pinReturn(tapLatLng, tapPin);
//           },
//         ),
//       ),
//     );
//   }

//   //この関数の戻り値でlatitudeとlongtitudeの値(端末の現在地)
//   Future<void> initLocation() async {
//     //メモ：多分位置を取得するのを許可している？
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
// //メモ：Geo~.get~で現在地の位置情報取得し、currentPositionに代入
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // double latitude = position.latitude; //メモ：現在地読み込み？
//     // double longitude = position.longitude;
//     // //取得した緯度経度からその地点の地名情報を取得する
//     // final placeMarks = await geoCoding.placemarkFromCoordinates(lat!, lng!);
//     // final placeMark = placeMarks[0];
//     // print("現在地の国は、${placeMark.country}");
//     // print("現在地の県は、${placeMark.administrativeArea}");
//     // print("現在地の市は、${placeMark.locality}");
//     setState(() {
//       lat = position.latitude;
//       lng = position.longitude;
//       //isLoading = false; // 追加: ローディング終了
//     });
//     initCircleMarker(lat!, lng!);
//     await loadSavedCapsules();
//     setState(() {
//       isLoading = false;
//     });

//     //initCircleMarker(lat!, lng!);
//   }

// //メモ：端末の現在地を青色の●で表示する関数
//   void initCircleMarker(double latitude, double longitude) {
//     CircleMarker circleMarker = CircleMarker(
//       color: Colors.indigo.withOpacity(0.9),
//       radius: 10,
//       borderColor: Colors.white.withOpacity(0.9),
//       borderStrokeWidth: 3,
//       point: LatLng(latitude, longitude),
//     );
//     print('initCircleMarkerはアプリ起動時に動く関数');
//     //print('lat1は${lat}lng1は${lng}');
//     //メモ：多分↓の行がないと●表示されない
//     circleMarkers.add(circleMarker);
//   }

//   void pinSizeChange() {}
// }
