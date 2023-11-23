import 'package:flutter/material.dart';
import '../theme_setting/Color_Scheme.dart';
//import '../Capsule_open/CapContents.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/SharedPreferences.dart';
//import 'TimlineButton.dart'; //なんでも開ける方
import 'newTimlineButton.dart'; //位置情報で500m以内か検知する方
import 'dart:async';
import 'package:geocoding/geocoding.dart' as geoCoding;
import '../theme_setting/HTTP_request.dart';

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
  // List<int> getCapsulesIdList() {
  //   return capsulesIdList;
  // }

  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userNameValue = await SharedPrefs.getUsername();
    final userIdValue = await SharedPrefs.getUserId();
    //final bioValue = await SharedPrefs.getMyBio();

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
      // Email または Password が null の場合の処理を追加
      return;
    }
    final userData = await ApiService.loginUser(Email!, Password!);
    final List<int> capsulesIdListnew =
        List<int>.from(userData['capsulesIdList'] ?? []);
    final List<double> capsulesLatListnew =
        List<double>.from(userData['capsuleLatList'] ?? []);
    final List<double> capsulesLonListnew =
        List<double>.from(userData['capsuleLonList'] ?? []);
    await SharedPrefs.setCapsulesIdList(capsulesIdListnew);
    await SharedPrefs.setCapsulesLatList(capsulesLatListnew);
    await SharedPrefs.setCapsulesLonList(capsulesLonListnew);

    print('capsulesIdList: $capsulesIdListnew');
    print('capsulesLatList: $capsulesLatListnew');
    print('capsulesLonList: $capsulesLonListnew');

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FutureBuilder<List<String>>(
                  future: _getCityNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final cityNames = snapshot.data as List<String>? ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 他のウィジェット
                            const SizedBox(height: 16),
                            CityButtonsWidget(
                              cityNames: cityNames,
                              userNames: userName != null
                                  ? List.filled(cityNames.length, userName!)
                                  : [],
                              userIds: userId != null
                                  ? List.filled(cityNames.length, userId!)
                                  : [],
                              capsuleId: capsulesIdList,
                              capsuleLatList: capsuleLatList,
                              capsuleLonList: capsuleLonList,
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          'データがありません',
                          style: const TextStyle(fontSize: 16),
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
        ));
  }

  Future<List<String>> _getCityNames() async {
    List<String> cityNames = [];

    for (int CaCount = 0; CaCount < capsulesIdList.length; CaCount++) {
      double latitude = capsuleLatList[CaCount];
      double longitude = capsuleLonList[CaCount];

      // ここで latitude と longitude を使って市区町村名を取得する処理を実行
      String cityName = await _getCityNameFromCoordinates(latitude, longitude);

      // 結果をリストに追加
      cityNames.add(
          cityName); //cityNames.add('$capsulesIdList[$CaCount] $cityName');
    }

    return cityNames;
  }

  // 任意のAPIやサービスを使って、座標から市区町村名を取得する関数
  Future<String> _getCityNameFromCoordinates(
      double latitude, double longitude) async {
    // ここに座標から市区町村名を取得するためのAPI呼び出しやロジックを実装
    // この例ではダミーのデータを返す
    final placeMarks =
        await geoCoding.placemarkFromCoordinates(latitude, longitude);
    final placeMark = placeMarks.isNotEmpty ? placeMarks.first : null;
    return placeMark?.locality ?? 'Unknown City';
  }
}
