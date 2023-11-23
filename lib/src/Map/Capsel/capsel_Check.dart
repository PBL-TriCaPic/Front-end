import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme_setting/Color_Scheme.dart';
//yamlにhttpを使用する記述を書く!
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences pref;
  String capsel_title = '';
  String audio_data = '';
  String image_pref = '';
  Image? picture_Return;
  File? imageFile;
  late Future<ApiResults> res;

  @override
  void initState() {
    super.initState();
    loadPref();
    Future<ApiResults> res = dataSend();
  }

  Future<void> loadPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      capsel_title = pref.getString('title')!;
      audio_data = pref.getString('nakami')!;
      //image_pref = pref.getString('image');

      final String? imagePath = pref.getString('imagepath');
      print('loadPref関数起動');
      if (imagePath != null) {
        imageFile = File(imagePath);
      }
      //final image = File(imageFile!.path);
    });
  }

  Future<void> getSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  /*Future<void> setImage() async {
    await getSharedPref();
  }*/

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('カプセル確認画面'),
        //backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        child: Column(//縦並び
            children: <Widget>[
          /*デコードした画像を表示したいボタン
          OutlinedButton(
            onPressed: () async {
              //ここもサーバのURL？
              Uri url = Uri.parse('');
              String body = json.decoder({
                'post_img': base64Image,
              });
              Response response = await http.post(url, body: body);
              final picture_Data = json.decode(response.body);
              String imageBase64 = picture_Data['result'];
              Uint8List bytes = base64Decode(imageBase64);
              Image image = Image.memory(bytes);
              picture_Return = image;
            },
            child: Text('画像を表示'),
          ),*/
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
            onPressed: () {
              dataSend();
              //カプセルを埋める演出を入れ、埋める
            },
            child: Text('埋める！'),
          ),
          ElevatedButton(
            child: Text('画像読み込み'),
            onPressed: () async {
              await getSharedPref();
              final String? imagePath = pref.getString('imagepath');
              if (imagePath != null) {
                imageFile = File(imagePath);
                imageFile;
                print('${imageFile} はボタン関数');
              }
            },
          ),
          Text('-タイトル-'),
          Text(capsel_title),
          Text('-中身-'),
          Text(audio_data),
          Text('エンコード画像'),
          Text(image_pref),
        ]),
      ),
    );
  }

  Future<ApiResults> dataSend() async {
    //Urlの場所 実機のIPアドレス 192.168.10.110 or　10.104.255.254
    //http://localhost:8307/index.php?route=/sql&db=Tricapic&table=capsules&pos=0
    final url = Uri.parse('http://10.104.255.254:8307/api/capsules');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      //'capsel_title': capsel_title,
      'audio_data': audio_data, //カプセルの中身
      //'picture':
    });
    print('ここまで関数動く');
    final response = await http.post(url, headers: headers, body: body);
    print('ここから関数動かない');
    if (response.statusCode == 200) {
      //final List<String> bytes = response.body;
      print('カプセル内容のPOSTリクエスト成功');
      print('サーバーレスポンスは：${response.body}です');
      return ApiResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('サーバに送るのを失敗しました');
    }
  }
}
