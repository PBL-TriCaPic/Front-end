import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/app.dart';
//追加import
import 'dart:ffi';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      //theme: themeProvider.selectedTheme,
      theme: lightTheme,
      // darkTheme: darkTheme,
      title: 'Flutter Demo',
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
//マップを表示する
  String _title = 'MyMap';
  double lat = 35.995; //メモ：最初に表示される場所を指定
  double lng = 138.158;
  var currentPosition; //メモ：現在地を取得する変数
  var currentHeading;
  LatLng? tapLatLng; //メモ：?はnullも許容

  List<Marker> markers = [];

  List<CircleMarker> circleMarkers = [
    //中身ないけど、削除すると現在地の●表示されなくなる
  ];

  @override
  void initState() {
    super.initState();
    /*var future = initLocation();
    future.then((newCorrentPosition) => print("get ${newCorrentPosition}"));*/
    Future<Position> newCorrentPosition = initLocation(); //現在地
    print('returnしたいもの${newCorrentPosition}');
  }

  //この関数の戻り値でlatitudeとlongtitudeの値(端末の現在地)
  Future<Position> initLocation() async {
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
    currentHeading = position.heading;
    currentPosition = position;
    double latitude = position.latitude; //メモ：現在地読み込み？
    double longtitude = position.longitude;
    initCircleMarker(latitude, longtitude);
    lat = latitude;
    lng = longtitude;
    if (mounted) {
      setState(() {
        print('currentPositionは${Geolocator.getCurrentPosition()}で端末の場所');
      });
    }
    return currentPosition;
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
        body: Container(
          child: FlutterMap(
            // マップ表示設定
            options: MapOptions(
                center: LatLng(lat, lng), //メモ:ここを変える
                zoom: 10.0,
                interactiveFlags: InteractiveFlag.all,
                enableScrollWheel: true,
                scrollWheelVelocity: 0.00001,
                onTap: (tapPosition, latLng) {
                  tapLatLng = latLng;
                  print(tapLatLng);
                  print("↑ピンを押したところの緯度経度");
                  //cleatePin(tapLatLng!);
                }),
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
        //右下のボタンの処理
        floatingActionButton: FloatingActionButton(
          //Iconの部分を書き換えるとアイコンのデザイン変更可
          child: Icon(
            Icons.close,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                //カプセル作成画面に遷移
                return capsel_Create();
              }),
            );
          },
        ),
        /*Column(
              children: [
                const Center(
                    child: Text('Map画面', style: TextStyle(fontSize: 32.0))),
                 Switch(
                   value: _light,
                   onChanged: (bool value) {
                     _toggleTheme();
                   },
                 ),
              ],
            )*/
      ),
    );
  }

  //ピンを作成する(現時点では表示はされない)
  void cleatePin(LatLng tapLatLng) {
    Marker marker = Marker(
      point: tapLatLng,
      width: 80,
      height: 80,
      builder: (context) => Container(
        child: IconButton(
          icon: Icon(
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
    markers.add(marker);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onTapPinCallBack(LatLng latLng) async {
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
          icon: Icon(
            Icons.location_on,
            size: 20,
            color: Colors.red,
          ),
          onPressed: () {
            pinReturn(tapLatLng, tapPin);
          },
        ),
      ),
    );
  }

  //メモ：端末の現在地を青色の●で表示する関数
  void initCircleMarker(double latitude, double longitude) {
    CircleMarker circleMarker = CircleMarker(
      color: Colors.indigo.withOpacity(0.9),
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
