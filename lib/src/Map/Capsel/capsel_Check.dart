import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/Map/Map.dart';
import 'package:flutter_application_develop/src/Profile/profile_edit.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:flutter_application_develop/src/theme_setting/HTTP_request.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme_setting/Color_Scheme.dart';
//yamlにhttpを使用する記述を書く!
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class capsel_Check extends StatelessWidget {
  const capsel_Check({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        capselLat = position.latitude;
        capselLon = position.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  late SharedPreferences pref;
  //String capsel_title = '';
  String? text_data;
  String? image_pref = '';
  String? userId;
  late double capselLat;
  late double capselLon;
  late Uint8List decode_Image;
  Image? picture_Return;
  File? imageFile;
  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    pref = await SharedPreferences.getInstance();
    final userIdValue = await SharedPrefs.getUserId();
    final nakami = await SharedPrefs.getCapselText();
    final impref = await SharedPrefs.getTakeImage();
    setState(() {
      userId = userIdValue;
      //final text_data = nakami;
      //ここでgetStringしないと中身nullになる
      text_data = pref.getString('nakami');
      final image_pref = impref;
      //撮影してエンコードした写真のデコード
      if (image_pref != null) {
        decode_Image = base64.decode(image_pref!);
      }

      final String? imagePath = pref.getString('imagepath');
      print('loadPref関数起動');
      if (imagePath != null) {
        imageFile = File(imagePath);
      }
      //final image = File(imageFile!.path);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('カプセル確認画面'),
        //backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(//縦並び
              children: <Widget>[
            //Text('-タイトル-'),
            //Text(capsel_title),
            Text('-中身-'),
            Text(text_data ?? 'テキストは空です'),
            Text('撮影した写真'),
            Image.memory(decode_Image),
            Text("以下の内容で埋めてもよろしいですか？"),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    //カプセル作成画面に遷移
                    return capsel_Create();
                  }),
                );
              },
              child: Text('戻る'),
            ),
            OutlinedButton(
              onPressed: () async {
                await getCurrentLocation(); // 位置情報を取得
                await ApiService.capselSend(
                    text_data, capselLat, capselLon, userId, image_pref);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MapScreen();
                    },
                  ),
                );
                //カプセルを埋める演出を入れ、埋める
              },
              child: Text('埋める！'),
            ),
          ]),
        ),
      ),
    );
  }
}
