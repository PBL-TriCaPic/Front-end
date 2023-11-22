import 'dart:ffi';
//import 'dart:html';
import 'package:flutter_application_develop/src/Map/Capsel/Picture_Check.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Check.dart';
import 'package:flutter_application_develop/src/Map/Capsel/picture_Check.dart';
import 'package:flutter_application_develop/src/Map/Map.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme_setting/Color_Scheme.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class capsel_Create extends StatelessWidget {
  const capsel_Create({super.key});

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
  int _counter = 0;
  /*image_pickerを利用するためのコード
  File _image;
  final picker = ImagePicker();*/

  String _apptitle = 'カプセル埋める';
  //タイトルと中身を保存する変数 pref
  late SharedPreferences pref;
  String capsel_title = '';
  String capsel_nakami = '';

  /*カメラ画面を表示する
  Future Camera_Show() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('imageが選択されていません');
      }
    });
  }*/

  //追記：位置情報取得
  String _location = "";
  Future<void> getLocation() async {
    // 現在の位置を返す
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("緯度: " + position.latitude.toString());
    // 東経がプラス、西経がマイナス
    print("経度: " + position.longitude.toString());

    setState(() {
      _location = position.toString();
    });
  }
  //追記部終わり

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  dynamic dateTime;

  //ロード時に読み込まれる関数たち
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    loadPref();
  }

//DatePicker設定画面
  _datePicker(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2003),
        lastDate: DateTime(2100));
    if (datePicked != null && datePicked != dateTime) {
      setState(() {
        dateTime = datePicked;
      });
    }
  }

  //この画面を読み込んだ時に保存したタイトルや中身を読み込んでる
  Future<void> loadPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      capsel_title = pref.getString('title')!;
      capsel_nakami = pref.getString('nakami')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    //カメラ表示追記
    final ImagePicker _picker = ImagePicker();
    var _textEditingController;
    return Scaffold(
        //キーボードを出した時に、bottom～のトラテープみたいなエラーを封じる
        resizeToAvoidBottomInset: false,

        //columnで画面範囲を超えてbottom～エラーが出た時に封じる↓
        //画面を下に引っ張って更新することは不可?
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 40, left: 20, right: 20), //画面全体の余白

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // 垂直方向上寄せ
                children: [
                  Container(
                    child: ButtonBar(
                      //横並びにする
                      alignment: MainAxisAlignment.spaceBetween, //幅を等しくする
                      children: [
                        //キャンセルボタンを押した時の処理
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  //マップ画面に遷移(Navigatorpopの方がいいかも？)
                                  return MapScreen();
                                }),
                              );
                            },
                            child: const Text(
                              "キャンセル",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )),

                        //次へボタンを押した時の処理
                        IconButton(
                            onPressed: () async {
                              //プリファレンスに保存している
                              final title_pref =
                                  await SharedPreferences.getInstance();
                              title_pref.setString('title', capsel_title);

                              final nakami_pref =
                                  await SharedPreferences.getInstance();
                              nakami_pref.setString('nakami', capsel_nakami);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  //カプセル確認画面に遷移
                                  return capsel_Check();
                                }),
                              );
                            },
                            icon: Icon(Icons.keyboard_double_arrow_right),
                            iconSize: 30,
                            color: Color.fromARGB(255, 142, 189, 237)),
                      ],
                    ),
                  ),

                  //撮影するボタン
                  /*Container(
                    child: Column(children: [
                      IconButton(
                        onPressed: () async {
                          //カメラ撮影画面に遷移
                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
                          Navigator.pop(context);
                          if (image != null)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => done(image),
                              ),
                            );
                        },
                        icon: Icon(Icons.camera),
                        iconSize: 50,

                        //child: const Text("撮影する！"),
                      ),
                    ]),
                  ),*/
                  Container(
                    width:
                        MediaQuery.of(context).size.width * 0.9, // 画面幅の90%に設定
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'タイトル',
                      ),
                      controller: _textEditingController,
                      maxLines: null, // または必要な行数
                      keyboardType: TextInputType.multiline,
                      // テキストフィールドをスクロール可能にするためにSingleChildScrollViewを使用,
                      onChanged: (text) {
                        // TODO: ここで取得したtextを使う
                        capsel_title = text;
                      },
                    ),
                  ),
                  SizedBox(height: 20.0), // 適切な間隔を設定
                  Container(
                    width:
                        MediaQuery.of(context).size.width * 0.9, // 画面幅の90%に設定
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '中身',
                      ),
                      controller: _textEditingController,
                      maxLines: null, // または必要な行数
                      keyboardType: TextInputType.multiline,
                      // テキストフィールドをスクロール可能にするためにSingleChildScrollViewを使用,
                      onChanged: (text) {
                        // TODO: ここで取得したtextを使う
                        capsel_nakami = text;
                      },
                    ),
                  ),

                  Text("$dateTime", style: TextStyle(fontSize: 25)),

                  ElevatedButton(
                    onPressed: () {
                      _datePicker(
                        context,
                      );
                    },
                    child: const Text("日付を変更"),
                  ),

                  //位置情報取得ボタン
                  ElevatedButton(
                    onPressed: () {
                      getLocation();
                    },
                    child: const Text("位置情報取得"),
                  ),
                  /*ボンドの画像
                  Image.network(
                    'https://pbs.twimg.com/media/FfHOaRIagAAxQlC.jpg',
                    width: 50,
                    height: 100,
                  ),*/

                  //位置情報テキスト
                  Text('$_location'),
                  //保存したプリファレンスを表示する
                  //Text(capsel_title, style: const TextStyle(fontSize: 30)),
                  //Text(capsel_nakami, style: const TextStyle(fontSize: 30)),
                ],
              ),
            ),
          ),
        ));
  }

  /*Future<ApiResults> data_Return() async {
    var url = "";
    var request = new data_Request(
        title: capsel_title,
        nakami: capsel_nakami,
        dateTime: dateTime,
        location: _location);
    final response = await http.post(url,
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return ApiResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('失敗した');
    }
  }*/
} //クラス終わり

//サーバにリクエストする為のデータクラス
class data_Request {
  final String title;
  final String nakami;
  final dynamic dateTime;
  final String location;
  data_Request({
    this.title = "",
    this.nakami = "",
    this.dateTime,
    this.location = "",
  });
  Map<String, dynamic> toJson() => {
        'title': title,
        'nakami': nakami,
      };
}

class ApiResults {
  final String title;
  final String nakami;
  final dynamic dateTime;
  final String location;
  ApiResults({
    this.title = "",
    this.nakami = "",
    this.dateTime,
    this.location = "",
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      title: json['title'],
      nakami: json['nakami'],
      dateTime: json['dateTime'],
      location: json['location'],
    );
  }
}
