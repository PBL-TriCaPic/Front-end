import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/theme_setting/Color_Scheme.dart';
import 'package:flutter_application_develop/src/theme_setting/HTTP_request.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// class FollowMapScreen extends StatelessWidget {
//   // ignore: use_super_parameters
//   const FollowMapScreen({Key? key}) : super(key: key);

//   @override
//   FollowHomeScreen createState() => FollowHomeScreen(title: '',);

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }

// }

class FollowHomeScreen extends StatefulWidget {
  const FollowHomeScreen({super.key, required this.title});

  final String title;

  @override
  State<FollowHomeScreen> createState() => _FollowHomeScreen();
}

class _FollowHomeScreen extends State<FollowHomeScreen> {
  //String _title = 'MyMap';
  double? lat; //メモ：最初に表示される場所を指定
  double? lng;
  LatLng? tapLatLng; //メモ：?はnullも許容
  //画像保存用のpreference
  //late SharedPreferences pref;
  late XFile image;

  File? imageFile;
  List<Marker> markers = [];
  List<CircleMarker> circleMarkers = []; //中身ないけど、削除すると現在地の●表示されなくなる
  bool isLoading = true; // 追加: ローディング状態を管理

   late SharedPreferences prefs;
  List<String> userName = [];
  List<String> userId = [];
  List<int> friendcapsulesIdList = [];
  List<double> friendcapsuleLatList = [];
  List<double> friendcapsuleLonList = [];


//他の人のピン表示
  // List<double> latListother = [];
  // List<double> lonListother = [];

  @override
  void initState() {
    super.initState();
    initLocation();
    //loadSavedCapsules(); // Load saved capsules on initialization
    //他の人のピン表示
    //loadOtherCapsules();
    _loadfriendcapdata();
  }

  Future<void> _loadfriendcapdata() async {
   final myuserId = await SharedPrefs.getUserId();

    try {
      final frienddata = await ApiService.fetchFriendsCapsules(myuserId!);

      // フレンドのカプセルデータを取得
      List<String> userIdValue = [];
      List<String> userNameValue = [];
      List<int> capsulesIdListValue = [];
      List<double> capsulesLatListValue = [];
      List<double> capsulesLonListValue = [];

      frienddata.forEach((capsule) {
        userIdValue.add(capsule["friendUserId"]);
        userNameValue.add(capsule["friendName"]);
        capsulesIdListValue.add(capsule["capsulesId"]);
        capsulesLatListValue.add(capsule["capsulesLat"]);
        capsulesLonListValue.add(capsule["capsulesLon"]);
      });

      // 以下の変数は消して構いません
      // final userNameValue = ['John Doe', 'もちゃ', 'ねこま', 'なさき', 'ねこま'];
      // final userIdValue = ['@123456', '@momo', '@nekoma', '@n_saki', '@nekoma'];
      // final capsulesIdListValue = [100, 101, 102, 103, 104];
      // final capsulesLatListValue = [
      //   41.815494446200134,
      //   41.83820963121419,
      //   41.851328225527055,
      //   41.84591764182999,
      //   41.848258151796124
      // ];
      // final capsulesLonListValue = [
      //   140.7534832958439,
      //   140.76897688843917,
      //   140.76695664722564,
      //   140.76611795200157,
      //   140.76781910626528,
      // ];

      var currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        userName = userNameValue;
        userId = userIdValue;
        friendcapsulesIdList = capsulesIdListValue;
        friendcapsuleLatList = capsulesLatListValue;
        friendcapsuleLonList = capsulesLonListValue;
      });
    } catch (e) {
      print('エラーが発生しました: $e');
    }

  }
// //他の人のピン表示 sharedpreferenceの中身をかえる
//   Future<void> loadOtherCapsules() async {
//     //バックから緯度経度をとる
//    latListother = await SharedPrefs.getCapsulesotherLatList();
//    lonListother = await SharedPrefs.getCapsulesotherLonList();

//     for (int i = 0; i < min(latListother.length, lonListother.length); i++) {
//       LatLng capsuleLatLng = LatLng(latListother[i], lonListother[i]);
//       createPinFromSavedCapsule(capsuleLatLng);
//     }
//   }

  Future<void> _refreshData() async {
    await _loadPreference();
  }

  Future<void> _loadPreference() async {
    final Email = await SharedPrefs.getEmail();
    final Password = await SharedPrefs.getPassword();

    if (Email == null || Password == null) {
      return;
    }
    final userData = await ApiService.loginUser(Email, Password);
    final List<int> capsulesIdListnew =
        List<int>.from(userData['capsulesIdList'] ?? []);
    final List<double> capsulesLatListnew =
        List<double>.from(userData['capsuleLatList'] ?? []);
    final List<double> capsulesLonListnew =
        List<double>.from(userData['capsuleLonList'] ?? []);
    await SharedPrefs.setCapsulesIdList(capsulesIdListnew);
    await SharedPrefs.setCapsulesLatList(capsulesLatListnew);
    await SharedPrefs.setCapsulesLonList(capsulesLonListnew);

    setState(() {
      friendcapsulesIdList = capsulesIdListnew.cast<int>();
      friendcapsuleLatList = capsulesLatListnew.cast<double>();
      friendcapsuleLonList = capsulesLonListnew.cast<double>();
      for(int i=0;i<friendcapsuleLatList.length; i++){
         LatLng capsuleLatLng = LatLng(friendcapsuleLatList[i], friendcapsuleLonList[i]);
    createPinFromSavedCapsule(capsuleLatLng);
      }
    });
  } //ここの処理まるまる変えてリフレッシュした時に友達のカプセルを更新できるようにする。

  
  void createPinFromSavedCapsule(LatLng capsuleLatLng) {
    Marker marker = Marker(
      point: capsuleLatLng,
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            size: 40,
            color: Colors.blue, // You can set your preferred color
          ),
          onPressed: () {
            // Handle tap on saved capsule pin if needed
          },
        ),
      ),
    );
    markers.add(marker);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //カメラ表示追記1行
    final ImagePicker _picker = ImagePicker();
    ThemeData selectedTheme = lightTheme;
    // 追加: isLoadingがtrueの場合はローディング表示
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: selectedTheme,
      home: Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   // title: Image.asset(
        //   //   'assets/TriCaPic_logo.png',
        //   //   height: 200,
        //   //   width: 200,
        //   // ),
        //   elevation: 3,
        //   shadowColor: Colors.black,



        //   //ボタンの動きを追加Map.dartへ
        //    actions: [
        //     // Wrap the IconButton with GestureDetector
        //     GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => MapScreen(),
        //           ),
        //         );
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //         child: Icon(Icons.people_alt_outlined),
        //       ),
        //     ),
        //   ],
        // ),
        body: Container(
          child: FlutterMap(
            // マップ表示設定
            options: MapOptions(
              center: LatLng(lat!, lng!), //メモ:ここを変える
              zoom: 15.0,
              interactiveFlags: InteractiveFlag.all,
              enableScrollWheel: true,
              scrollWheelVelocity: 0.00001,
              // onTap: (tapPosition, latLng) {
              //   tapLatLng = latLng;
              //   print(tapLatLng);
              //   print("↑ピンを押したところの緯度経度");
              //   cleatePin(tapLatLng!);
              // },
            ),
            layers: [
              //背景地図読み込み (OSM)
              TileLayerOptions(
                urlTemplate: "https://tile.openstreetmap.jp/{z}/{x}/{y}.png",
              ),
              // サークルマーカー設定
              CircleLayerOptions(
                circles: circleMarkers,
              ),
              // ピンマーカー設定
              MarkerLayerOptions(
                markers: markers,
              ),
            ],
          ),
        ),

      
      ),
    );
  }

  //ピンを作成する
  void cleatePin(LatLng tapLatLng) {
    Marker marker = Marker(
      point: tapLatLng,
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            size: 40,
            color: Colors.red,
          ),
          onPressed: () {
            onTapPinCallBack(tapLatLng);
          },
        ),
      ),
    );
    //BottomNavigatorを押しまくった時に、エラーが出るのを防いでくれるかもしれない記述
    markers.add(marker);
    if (mounted) {
      setState(() {});
    }
  }

  void onTapPinCallBack(LatLng latLng) {
    final tapMarker = pinReturn(latLng, pinReturn);
    markers.add(tapMarker);
    markers.removeAt(1);
    print('Pinをタップしたよ');
    if (mounted) {
      setState(() {});
    }
  }

  Marker pinReturn(LatLng tapLatLng, void tapPin) {
    return Marker(
      point: tapLatLng,
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            size: 20,
            color: Colors.red,
          ),
          onPressed: () {
          //  pinReturn(tapLatLng, tapPin);
          },
        ),
      ),
    );
  }

  //この関数の戻り値でlatitudeとlongtitudeの値(端末の現在地)
  Future<void> initLocation() async {
    //メモ：多分位置を取得するのを許可している？
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
//メモ：Geo~.get~で現在地の位置情報取得し、currentPositionに代入
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // double latitude = position.latitude; //メモ：現在地読み込み？
    // double longitude = position.longitude;
    // //取得した緯度経度からその地点の地名情報を取得する
    // final placeMarks = await geoCoding.placemarkFromCoordinates(lat!, lng!);
    // final placeMark = placeMarks[0];
    // print("現在地の国は、${placeMark.country}");
    // print("現在地の県は、${placeMark.administrativeArea}");
    // print("現在地の市は、${placeMark.locality}");
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      isLoading = false; // 追加: ローディング終了
    });

    initCircleMarker(lat!, lng!);
  }

//メモ：端末の現在地を青色の●で表示する関数
  void initCircleMarker(double latitude, double longitude) {
    CircleMarker circleMarker = CircleMarker(
      color: const Color.fromARGB(255, 93, 181, 63).withOpacity(0.9),
      radius: 10,
      borderColor: Colors.white.withOpacity(0.9),
      borderStrokeWidth: 3,
      point: LatLng(latitude, longitude),
    );
    print('initCircleMarkerはアプリ起動時に動く関数');
    //print('lat1は${lat}lng1は${lng}');
    //メモ：多分↓の行がないと●表示されない
    circleMarkers.add(circleMarker);
  }

  void pinSizeChange() {}
}

  
  

