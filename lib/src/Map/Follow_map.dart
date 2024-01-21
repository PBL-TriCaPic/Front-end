// ignore_for_file: file_names, void_checks, avoid_print

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

      for (var capsule in frienddata) {
        userIdValue.add(capsule["friendUserId"]);
        userNameValue.add(capsule["friendName"]);
        capsulesIdListValue.add(capsule["capsulesId"]);
        capsulesLatListValue.add(capsule["capsulesLat"]);
        capsulesLonListValue.add(capsule["capsulesLon"]);
      }

      setState(() {
        userName = userNameValue;
        userId = userIdValue;
        friendcapsulesIdList = capsulesIdListValue;
        friendcapsuleLatList = capsulesLatListValue;
        friendcapsuleLonList = capsulesLonListValue;

        // 新しく追加：ピンを立てるメソッドを呼び出す
        _addFriendCapsulePins();
      });
    } catch (e) {
      print('エラーが発生しました: $e');
    }
  }

  void _addFriendCapsulePins() {
    for (int i = 0; i < friendcapsuleLatList.length; i++) {
      LatLng capsuleLatLng = LatLng(
        friendcapsuleLatList[i],
        friendcapsuleLonList[i],
      );
      createFriendCapsulePin(capsuleLatLng);
    }
  }

  void createFriendCapsulePin(LatLng capsuleLatLng) {
    Marker marker = Marker(
      point: capsuleLatLng,
      width: 80,
      height: 80,
      builder: (context) => IconButton(
        icon: const Icon(
          Icons.location_on,
          size: 40,
          color: Colors.blue, // お好みの色に変更可能
        ),
        onPressed: () {
          // ピンがタップされた時の処理を追加する場合はここに記述
        },
      ),
    );

    markers.add(marker);

    if (mounted) {
      setState(() {});
    }
  }

//ここの処理まるまる変えてリフレッシュした時に友達のカプセルを更新できるようにする。

  void createPinFromSavedCapsule(LatLng capsuleLatLng) {
    Marker marker = Marker(
      point: capsuleLatLng,
      width: 80,
      height: 80,
      builder: (context) => IconButton(
        icon: const Icon(
          Icons.location_on,
          size: 40,
          color: Colors.blue, // You can set your preferred color
        ),
        onPressed: () {
          // Handle tap on saved capsule pin if needed
        },
      ),
    );
    markers.add(marker);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
        body: FlutterMap(
          // マップ表示設定
          options: MapOptions(
            center: LatLng(lat!, lng!), //メモ:ここを変える
            zoom: 15.0,
            interactiveFlags: InteractiveFlag.all,
            enableScrollWheel: true,
            scrollWheelVelocity: 0.00001,
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
    );
  }

  //ピンを作成する
  void cleatePin(LatLng tapLatLng) {
    Marker marker = Marker(
      point: tapLatLng,
      width: 80,
      height: 80,
      builder: (context) => IconButton(
        icon: const Icon(
          Icons.location_on,
          size: 40,
          color: Colors.red,
        ),
        onPressed: () {
          onTapPinCallBack(tapLatLng);
        },
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
      builder: (context) => IconButton(
        icon: const Icon(
          Icons.location_on,
          size: 20,
          color: Colors.red,
        ),
        onPressed: () {
          //  pinReturn(tapLatLng, tapPin);
        },
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
}
