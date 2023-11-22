import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'Timeline.dart';
import '../Capsule_open/Capcontents.dart';

class CityButtonsWidget extends StatelessWidget {
  final List<String> cityNames;
  final List<String> userNames;
  final List<String> userIds;
  final List<String> capsuleId;
  final List<double> capsuleLatList;
  final List<double> capsuleLonList;

  const CityButtonsWidget({
    Key? key,
    required this.cityNames,
    required this.userNames,
    required this.userIds,
    required this.capsuleId,
    required this.capsuleLatList,
    required this.capsuleLonList,
  }) : super(key: key);

  //Position? _currentPosition; // 位置情報を格納する変数

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    // double widgetWidth = deviceWidth * 0.9; // 画面幅の90％に設定
    // double deviceheight = MediaQuery.of(context).size.height;
    // double appBarHeight = kToolbarHeight; // AppBarの高さ
    // double bottomNavigationBarHeight = kBottomNavigationBarHeight;

    // // BottomNavigationBarとAppBarの高さを除いた画面の高さ
    // double screenHeightWithoutNavBars =
    //     deviceheight - appBarHeight - bottomNavigationBarHeight;

    return SizedBox(
      height: MediaQuery.of(context)
          .size
          .height, //screenHeightWithoutNavBars, // 適切な高さを指定
      width: MediaQuery.of(context).size.width, //widgetWidth,
      child: GridView.builder(
        shrinkWrap: false, // グリッドの高さに合わせてシュリンク
        padding: EdgeInsets.zero, // 余白をゼロにするか確認
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 列数を指定
          crossAxisSpacing: 20.0, // 列間のスペース
          mainAxisSpacing: 20.0, // 行間のスペース
        ),
        itemCount: cityNames.length,
        itemBuilder: (context, index) {
          return _buildCityButton(context, index);
        },
      ),
    );
  }

  Widget _buildCityButton(BuildContext context, int index) {
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
          currentPosition!.latitude,
          currentPosition!.longitude,
          targetLatitude, // ボタンの緯度
          targetLongitude, // ボタンの経度
        );

        // 距離が500メートル以内なら通常の画面表示
        if (distanceInMeters <= 500) {
          print('Selected Capsule ID: ${capsuleId[index]}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CapContentsScreen(
                capsuleId: capsuleId[index],
                cityName: cityNames[index],
              ),
            ),
          );
        } else {
          // 500メートル以上ならダイアログ表示
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('注意'),
                content: Text('ボタンが500メートル以上離れています。'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 垂直方向に中央寄せ
        children: [
          Text(
            '${userNames[index]}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20), // テキストサイズを指定
          ),
          Text(
            '${userIds[index]}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15), // テキストサイズを指定
          ),
          Text(
            '${cityNames[index]}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20), // テキストサイズを指定
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16), // パディング
        minimumSize: Size(10, 10), // 最小サイズ
        shape: CircleBorder(),
        elevation: 10, // 影の大きさ
        primary: Colors.white, // 背景色
      ),
    );
  }
}
