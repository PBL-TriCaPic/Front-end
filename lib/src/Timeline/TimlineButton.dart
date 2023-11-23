import 'package:flutter/material.dart';
import '../Capsule_open/Capcontents.dart';

class CityButtonsWidget extends StatelessWidget {
  final List<String> cityNames;
  final List<String> userNames;
  final List<String> userIds;
  final List<int> capsuleId;
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
    //print('capsuleId[$index]: ${capsuleId[index]}'); // デバッグプリントを追加
    return ElevatedButton(
      onPressed: () async {
        //print('Selected Capsule ID: ${capsuleId[index]}'); // 追加
        //await _handleButtonPress(context, index);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CapContentsScreen(
                capsuleId:
                    capsuleId[index].toString(), // toString()で明示的にString型に変換
                cityName: cityNames[index]), //掘り起こす演出このへん
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        minimumSize: Size(100, 100),
        shape: CircleBorder(),
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
              '${userNames[index]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
            ),
            Text(
              '${userIds[index]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold), // テキストサイズを指定
            ),
            Text(
              '${cityNames[index]}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold), // テキストサイズを指定
            ),
          ],
        ),
      ),
    );
  }
}
