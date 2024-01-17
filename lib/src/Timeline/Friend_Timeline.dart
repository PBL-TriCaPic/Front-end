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
  late Position currentPosition;
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

      currentPosition = await Geolocator.getCurrentPosition(
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

  Future<void> _refreshData() async {
    await _loadfriendcapdata();
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
                      return _buildCityImage(context, index, cityNames);
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

  Widget _buildCityImage(
      BuildContext context, int index, List<String> cityNames) {
    double targetLatitude = friendcapsuleLatList[index];
    double targetLongitude = friendcapsuleLonList[index];

    // Calculate distance
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      targetLatitude,
      targetLongitude,
    );

    // 500メートル以内かどうかに基づいて画像パスを設定
    String imagePath = (distanceInMeters <= 500)
        ? 'assets/Capsule_open.PNG' // 500メートル以内ならこの画像
        : 'assets/Capsule_not_open.PNG'; // 500メートル以上ならこの画像

    return GestureDetector(
      onTap: () async {
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
          //print('Selected Capsule ID: ${capsuleId[index]}');
          // ignore: use_build_context_synchronously
          screenTransitionAnimation(context, () {
            Navigator.of(context).push(_createRoute(friendcapsulesIdList[index],
                cityNames[index], userName[index], userId[index]));
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
      child: Stack(
        alignment: Alignment.center, // 子要素の中央に配置
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, // 画像を丸く切り取る
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  //offset: Offset(0, 5),
                ),
              ],
            ),
            child: Image.asset(
              imagePath,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            // テキストの配置位置を指定
            //bottom: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 垂直方向に中央寄せ
              children: [
                Text(
                  userName[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), // テキストサイズを指定
                ),
                Text(
                  userId[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), // テキストサイズを指定
                ),
                Text(
                  cityNames[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ), // テキストサイズを指定
                ),
              ],
            ),
          ),
        ],
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
