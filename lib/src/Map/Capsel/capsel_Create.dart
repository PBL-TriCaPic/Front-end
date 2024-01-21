// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, camel_case_types, avoid_print

import 'dart:typed_data';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Check.dart';
import 'package:flutter_application_develop/src/Map/Map.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';
import 'package:flutter/material.dart';
import '../../theme_setting/Color_Scheme.dart';
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
  //int _counter = 0;
  //タイトルと中身を保存する変数 pref
  late SharedPreferences pref;
  String capsel_title = '';
  String capsel_nakami = '';
  //File? imageFile;
  Uint8List? decode_Image;
  String? image_pref = '';

  @override
  void initState() {
    super.initState();
    //dateTime = DateTime.now();
    loadPref();
  }

  //この画面を読み込んだ時に保存したタイトルや中身を読み込んでる
  Future<void> loadPref() async {
    pref = await SharedPreferences.getInstance();
    image_pref = await SharedPrefs.getTakeImage();
    //capsel_nakami = (await SharedPrefs.getCapselText())!;
    setState(() {
      image_pref = image_pref;
      if (image_pref != null) {
        decode_Image = base64.decode(image_pref!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController(text: capsel_nakami);
    return Scaffold(
        //キーボードを出した時に、bottom～のトラテープみたいなエラーを封じる
        resizeToAvoidBottomInset: false,
        //columnで画面範囲を超えてbottom～エラーが出た時に封じるSingleChild～↓
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
                  ButtonBar(
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
                                return const MapScreen();
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
                            await SharedPrefs.setCapselText(capsel_nakami);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                //カプセル確認画面に遷移
                                return const capsel_Check();
                              }),
                            );
                          },
                          icon: const Icon(Icons.keyboard_double_arrow_right),
                          iconSize: 30,
                          color: const Color.fromARGB(255, 142, 189, 237)),
                    ],
                  ),
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width * 0.9, // 画面幅の90%に設定
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: '中身',
                      ),
                      controller: textEditingController,
                      maxLines: null, // または必要な行数
                      keyboardType: TextInputType.multiline,
                      // テキストフィールドをスクロール可能にするためにSingleChildScrollViewを使用,
                      onChanged: (text) {
                        // ここで取得したtextを使う
                        capsel_nakami = text;
                      },
                      //initialValue: capsel_nakami,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.memory(decode_Image!),
                ],
              ),
            ),
          ),
        ));
  }
} //クラス終わり