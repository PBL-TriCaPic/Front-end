import 'dart:convert';
import 'package:flutter/material.dart';
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
    super.key,
    required this.cityNames,
    required this.userNames,
    required this.userIds,
    required this.capsuleId,
    required this.capsuleLatList,
    required this.capsuleLonList,
  });

  @override
  Widget build(BuildContext context) {
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
        print('Selected Capsule ID: ${capsuleId[index]}'); // 追加
        //await _handleButtonPress(context, index);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapContentsScreen(
                capsuleId: capsuleId[index], cityName: cityNames[index]),
          ),
        );
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

// Future<void> _handleButtonPress(BuildContext context, int index) async {
//   // 非同期処理をここに書く
//   // 例: 非同期処理が終わるまで待つ
//   await Future.delayed(Duration(seconds: 2));
//   // ボタンを有効にする
//   (context as Element).markNeedsBuild();
// }
