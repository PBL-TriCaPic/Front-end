// ignore_for_file: file_names, library_prefixes, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/SharedPreferences.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart' as geoCoding;
import '../theme_setting/HTTP_request.dart';
import '../Capsule_open/Capcontents.dart';
import 'package:geolocator/geolocator.dart';
import '../Animation/Capsule_Open_Animation.dart';

class FriendTab extends StatefulWidget {
  const FriendTab({super.key});

  @override
  State<FriendTab> createState() => FriendTabState();
}

class FriendTabState extends State<FriendTab> {
  // ここに第二のタブのコードを書きます
  late SharedPreferences prefs;
  List<String> userName = [];
  List<String> userId = [];
  List<int> friendcapsulesIdList = [];
  List<double> friendcapsuleLatList = [];
  List<double> friendcapsuleLonList = [];

  @override
  void initState() {
    super.initState();
    _loadfriendcapdata();
  }

  Future<void> _loadfriendcapdata() async {
    // final userNameValue = await SharedPrefs.getUsername();
    // final userIdValue = await SharedPrefs.getUserId();

    // final capsulesIdListValue = await SharedPrefs.getCapsulesIdList();
    // final capsulesLatListValue = await SharedPrefs.getCapsulesLatList();
    // final capsulesLonListValue = await SharedPrefs.getCapsulesLonList();
    //ここでバックエンドにリクエスト
    final userNameValue = ['John Doe', 'もちゃ', 'ねこま', 'なさき', 'ねこま'];
    final userIdValue = ['@123456', '@momo', '@nekoma', '@n_saki', '@nekoma'];
    final capsulesIdListValue = [100, 101, 102, 103, 104];
    final capsulesLatListValue = [
      41.815494446200134,
      41.83820963121419,
      41.851328225527055,
      41.84591764182999,
      41.848258151796124
    ];
    final capsulesLonListValue = [
      140.7534832958439,
      140.76897688843917,
      140.76695664722564,
      140.76611795200157,
      140.76781910626528,
    ];

    setState(() {
      userName = userNameValue;
      userId = userIdValue;
      friendcapsulesIdList = capsulesIdListValue;
      friendcapsuleLatList = capsulesLatListValue;
      friendcapsuleLonList = capsulesLonListValue;
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
      friendcapsulesIdList = capsulesIdListnew.cast<int>();
      friendcapsuleLatList = capsulesLatListnew.cast<double>();
      friendcapsuleLonList = capsulesLonListnew.cast<double>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

    for (int CaCount = 0; CaCount < friendcapsulesIdList.length; CaCount++) {
      double latitude = friendcapsuleLatList[CaCount];
      double longitude = friendcapsuleLonList[CaCount];

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
    return ElevatedButton(
      onPressed: () async {
        // 位置情報を取得
        Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        double targetLatitude = friendcapsuleLatList[index];
        double targetLongitude = friendcapsuleLonList[index];

        // ボタンの位置と現在位置との距離を計測
        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          targetLatitude, // ボタンの緯度
          targetLongitude, // ボタンの経度
        );

        // 距離が500メートル以内なら通常の画面表示
        if (distanceInMeters <= 500) {
          // ignore: use_build_context_synchronously
          screenTransitionAnimation(context, () {
            Navigator.of(context).push(_createRoute(
              friendcapsulesIdList[index],
              cityNames[index],
              userName[index],
              userId[index],
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
                    const SizedBox(height: 10),
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
              userName[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              userId[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              cityNames[index],
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
  }
  //500m以内
}

Route _createRoute(
    int capsuleId, String cityName, String userName, String userId) {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => CapContentsScreen(
      capsuleId: capsuleId.toString(),
      cityName: cityName,
      userName: userName,
      userId: userId,
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
