import 'dart:ffi';
//import 'dart:html';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Check.dart';
import 'package:flutter_application_develop/src/Map/Capsel/pucture_View.dart';
import 'package:flutter_application_develop/src/Map/Map.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme_setting/Color_Scheme.dart';

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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  /*image_pickerを利用するためのコード
  File _image;
  final picker = ImagePicker();*/

  String _apptitle = 'カプセル埋める';
  String title = '';
  String nakami = '';

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

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    //カメラ表示追記
    final ImagePicker _picker = ImagePicker();
    var _textEditingController;
    return Scaffold(
        //キーボードを出した時に、bottom～のトラテープみたいなエラーを封じる
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        // ),

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
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                //マップ画面に遷移(Navigatorpopの方がいいかも？)
                                return Sample2();
                              }),
                            );
                          },
                          child: const Text("次へ",
                              style: TextStyle(
                                fontSize: 16,
                              )),
                        ),
                      ])),

                  //撮影するボタン
                  Container(
                    child: Column(children: [
                      IconButton(
                        onPressed: () async {
                          //カメラ撮影画面に遷移
                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.camera,
                          );
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
                  ),
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
                        title = text;
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
                        nakami = text;
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
                  //仮
                  Image.network(
                    'https://pbs.twimg.com/media/FfHOaRIagAAxQlC.jpg',
                    width: 50,
                    height: 100,
                  ),

                  //位置情報テキスト
                  Text('$_location'),
                ],
              ),
            ),
          ),
        ));
  }
}
