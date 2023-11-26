import 'package:flutter/material.dart';
import '../theme_setting/Color_Scheme.dart';
//import '../Capsule_open/CapContents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/SharedPreferences.dart';
//import 'TimelineButton.dart'; //なんでも開ける方
//import 'newTimelineButton.dart'; //位置情報で500m以内か検知する方
import 'dart:async';
import 'package:geocoding/geocoding.dart' as geoCoding;
import '../theme_setting/HTTP_request.dart';
import '../Capsule_open/Capcontents.dart';
import 'package:geolocator/geolocator.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: _timeline(),
    );
  }
}

class _timeline extends StatefulWidget {
  @override
  State<_timeline> createState() => _timelinePageState();
}

class _timelinePageState extends State<_timeline> {
  late SharedPreferences prefs;
  String? userName;
  String? userId;
  List<int> capsulesIdList = [];
  List<double> capsuleLatList = [];
  List<double> capsuleLonList = [];

  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userNameValue = await SharedPrefs.getUsername();
    final userIdValue = await SharedPrefs.getUserId();

    final capsulesIdListValue = await SharedPrefs.getCapsulesIdList();
    final capsulesLatListValue = await SharedPrefs.getCapsulesLatList();
    final capsulesLonListValue = await SharedPrefs.getCapsulesLonList();

    setState(() {
      userName = userNameValue;
      userId = userIdValue;
      capsulesIdList = capsulesIdListValue;
      capsuleLatList = capsulesLatListValue.cast<double>();
      capsuleLonList = capsulesLonListValue.cast<double>();
    });
  }

  Future<void> _refreshData() async {
    await _loadPreference();
  }

  Future<void> _loadPreference() async {
    final Email = await SharedPrefs.getEmail();
    final Password = await SharedPrefs.getPassward();

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
      capsulesIdList = capsulesIdListnew.cast<int>();
      capsuleLatList = capsulesLatListnew.cast<double>();
      capsuleLonList = capsulesLonListnew.cast<double>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: RefreshIndicator(
          onRefresh: _refreshData,
          // child: Padding(
          //   padding: const EdgeInsets.all(16.0),
          child: Center(
            child: FutureBuilder<List<String>>(
              future: _getCityNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final cityNames = snapshot.data as List<String>? ?? [];

                    return GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0, // 列間のスペース
                        mainAxisSpacing: 20.0,
                      ),
                      itemCount: cityNames.length,
                      itemBuilder: (context, index) {
                        return _buildCityButton(context, index, cityNames);
                      },
                    );
                  } else {
                    return const Text(
                      'データがありません',
                      style: TextStyle(fontSize: 16),
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }

  Future<List<String>> _getCityNames() async {
    List<String> cityNames = [];

    for (int CaCount = 0; CaCount < capsulesIdList.length; CaCount++) {
      double latitude = capsuleLatList[CaCount];
      double longitude = capsuleLonList[CaCount];

      String cityName = await _getCityNameFromCoordinates(latitude, longitude);

      cityNames.add(cityName);
    }

    return cityNames;
  }

  Future<String> _getCityNameFromCoordinates(
      double latitude, double longitude) async {
    final placeMarks =
        await geoCoding.placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks.isNotEmpty ? placeMarks.first : null;
    return placeMark?.locality ?? 'Unknown City';
  }

  Widget _buildCityButton(
      BuildContext context, int index, List<String> cityNames) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapContentsScreen(
              capsuleId: capsulesIdList[index].toString(),
              cityName: cityNames[index],
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(10, 10),
        shape: const CircleBorder(),
        elevation: 10,
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/TimeCapsule.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        width: 250,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${userName ?? ""}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${userId ?? ""}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${cityNames[index]}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  } //ボタン

  // Widget _buildCityButton(
  //     BuildContext context, int index, List<String> cityNames) {
  //   //final int currentCapsuleId = timelinePageState.getCapsulesIdList()[index];
  //   return ElevatedButton(
  //     onPressed: () async {
  //       // 位置情報を取得
  //       Position currentPosition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best,
  //       );
  //       double targetLatitude = capsuleLatList[index];
  //       double targetLongitude = capsuleLonList[index];

  //       // ボタンの位置と現在位置との距離を計測
  //       double distanceInMeters = Geolocator.distanceBetween(
  //         currentPosition.latitude,
  //         currentPosition.longitude,
  //         targetLatitude, // ボタンの緯度
  //         targetLongitude, // ボタンの経度
  //       );

  //       // 距離が500メートル以内なら通常の画面表示
  //       if (distanceInMeters <= 500) {
  //         //print('Selected Capsule ID: ${capsuleId[index]}');
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => CapContentsScreen(
  //               capsuleId: capsulesIdList[index].toString(),
  //               cityName: cityNames[index],
  //             ),
  //           ),
  //         );
  //       } else {
  //         // 500メートル以上ならダイアログ表示
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text('注意'),
  //               content: Text('ボタンが500メートル以上離れています。'),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('OK'),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     },
  //     style: ElevatedButton.styleFrom(
  //       padding: EdgeInsets.all(16),
  //       minimumSize: Size(100, 100),
  //       shape: CircleBorder(),
  //       elevation: 10,
  //       //primary: Colors.transparent, // 背景色を透明に設定
  //     ),
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage(
  //             'assets/TimeCapsule.PNG',
  //           ), // 画像のパス
  //           fit: BoxFit.cover, // 画像をボタンにフィットさせるかどうか
  //         ),
  //       ),
  //       width: 250, // 任意の幅を指定
  //       height: 250, // 任意の高さを指定
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center, // 垂直方向に中央寄せ
  //         children: [
  //           Text(
  //             '${userName ?? ""}',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
  //           ),
  //           Text(
  //             '${userId ?? ""}',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 fontSize: 15, fontWeight: FontWeight.bold), // テキストサイズを指定
  //           ),
  //           Text(
  //             '${cityNames[index]}',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
