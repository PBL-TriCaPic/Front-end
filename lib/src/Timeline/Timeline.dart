// ignore_for_file: file_names, library_prefixes, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme_setting/Color_Scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/SharedPreferences.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart' as geoCoding;
import '../theme_setting/HTTP_request.dart';
import '../Capsule_open/Capcontents.dart';
import 'package:geolocator/geolocator.dart';
import '../Animation/Capsule_Open_Animation.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
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

  @override
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
        child: Center(
          child: FutureBuilder<List<String>>(
            future: _getCityNames(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final cityNames = snapshot.data ?? [];
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.0,
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
      ),
    );
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

  // Widget _buildCityButton(
  //     BuildContext context, int index, List<String> cityNames) {
  //   return ElevatedButton(
  //     onPressed: () async {
  //       screenTransitionAnimation(context, () {
  //         Navigator.of(context).push(_createRoute(
  //           capsulesIdList[index],
  //           cityNames[index],
  //         ));
  //       });
  //     },
  //     style: ElevatedButton.styleFrom(
  //       padding: const EdgeInsets.all(16),
  //       minimumSize: const Size(10, 10),
  //       shape: const CircleBorder(),
  //       elevation: 10,
  //     ),
  //     child: Container(
  //       decoration: const BoxDecoration(
  //         image: DecorationImage(
  //           image: AssetImage('assets/TimeCapsule.PNG'),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       width: 250,
  //       height: 250,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             '${userName ?? ""}',
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             '${userId ?? ""}',
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           Text(
  //             '${cityNames[index]}',
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }//どこのでも行ける

  Widget _buildCityButton(
      BuildContext context, int index, List<String> cityNames) {
    //final int currentCapsuleId = timelinePageState.getCapsulesIdList()[index];
    return ElevatedButton(
      onPressed: () async {
        // 位置情報を取得
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        double targetLatitude = capsuleLatList[index];
        double targetLongitude = capsuleLonList[index];

        // ボタンの位置と現在位置との距離を計測
        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          targetLatitude, // ボタンの緯度
          targetLongitude, // ボタンの経度
        );

        // 距離が500メートル以内なら通常の画面表示
        if (distanceInMeters <= 500) {
          //print('Selected Capsule ID: ${capsuleId[index]}');
          // ignore: use_build_context_synchronously
          screenTransitionAnimation(context, () {
            Navigator.of(context).push(_createRoute(
              capsulesIdList[index],
              cityNames[index],
            ));
          });
        } else {
          // 500メートル以上ならダイアログ表示
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              double distanceToShow = distanceInMeters;
              String distanceUnit = 'm';

              if (distanceInMeters >= 1000) {
                // 1000メートル以上なら1キロメートルに変換
                distanceToShow = distanceInMeters / 1000;
                distanceUnit = 'km';
              }
              return AlertDialog(
                title: const Text('注意'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      'assets/Capsule_Not_Found.json', // Lottie アニメーションのファイルパス
                    ),
                    const Text('このカプセルは遠すぎて開けられないよ！'),
                    const SizedBox(height: 10), // 適切なスペースを追加
                    Text(
                        'カプセルまであと ${distanceToShow.toStringAsFixed(2)} $distanceUnit'),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        minimumSize: const Size(100, 100),
        shape: const CircleBorder(),
        elevation: 10,
        //primary: Colors.transparent, // 背景色を透明に設定
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/TimeCapsule.PNG',
            ), // 画像のパス
            fit: BoxFit.cover, // 画像をボタンにフィットさせるかどうか
          ),
        ),
        width: 250, // 任意の幅を指定
        height: 250, // 任意の高さを指定
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直方向に中央寄せ
          children: [
            Text(
              userName ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
            ),
            Text(
              userId ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold), // テキストサイズを指定
            ),
            Text(
              cityNames[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
            ),
          ],
        ),
      ),
    );
  } //500m以内
}

Route _createRoute(int capsuleId, String cityName) {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => CapContentsScreen(
      capsuleId: capsuleId.toString(),
      cityName: cityName,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.linear));
      return FadeTransition(
        opacity: animation.drive(tween),
        child: child,
      );
    },
  );
}
