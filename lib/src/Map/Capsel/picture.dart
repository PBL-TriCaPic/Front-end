import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Check.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/Map/Map.dart';
import 'package:flutter_application_develop/src/Profile/Profile.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class PictureCheck extends StatelessWidget {
  PictureCheck(this.image, {Key? key}) : super(key: key);
  final XFile image;
  late SharedPreferences pref;
  File? imageFile;

/*class MyHomePage extends StatefulWidget {
  final File image;
  const MyHomePage({super.key, required this.title, required this.image});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}*/

/*@override
  void initState() {
    initState();
    loadPref();
  }

  Future<void> loadPref() async {
    late SharedPreferences pref;
    pref = await SharedPreferences.getInstance();
    setState(() {
      image_pref = pref.getString('title')!;
    });
  }*/
//class MyHomePageState extends State<MyHomePage> {

  //late XFile image;

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return Scaffold(
      body: Column(children: [
        Center(
          child: Image.file(
            //撮影した画像を表示
            File(image.path),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
        ),
        //画像をサーバにアップロード
        /*ElevatedButton(
            child: Text('アップロード'),
            onPressed: () async {
              //awaitの記述は必須 readAsBytesSyncは使えないぽい
              List<int> imageBytes = await image.readAsBytes();
              String base64Image = base64Encode(imageBytes);
              //print("エンコード関数");
              print('${base64Image}関数');
              //サーバのURLを指定する
              Uri url = Uri.parse('');
              String body = json.encode({
                'image.path': base64Image,
              });
              /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return capsel_Create();
                },
              ),
            );*/
            }),*/

        //カプセル作成画面に遷移
        ElevatedButton(
          child: Text('次へ進む'),
          onPressed: () async {
            //awaitの記述は必須 readAsBytesSyncは使えないぽい
            List<int> imageBytes = await image.readAsBytes();
            String base64Image = base64Encode(imageBytes);
            //写真をエンコードして、文字列をプリファレンスに保存
            print('${base64Image}関数');
            final imagepref = await SharedPreferences.getInstance();
            imagepref.setString('image', base64Image);
            File aFile = File(image.path);
            await saveImagePath(aFile);
            //setState();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return capsel_Create();
                },
              ),
            );
          },
        ),
        ElevatedButton(
          child: Text('撮りなおす'),
          onPressed: () async {
            //カメラ撮影画面に遷移
            final XFile? image = await _picker.pickImage(
              source: ImageSource.camera,
            );
          },
        ),
      ]),
    );
  }

  Future<void> saveImagePath(File File) async {
    getSharedPref();
    //if (image != null) {
    //await pref.setString('imagepath', image!.path);
    //setState(() {});
    final appDir = await getApplicationDocumentsDirectory();
    const fileName = 'profile_image.jpg';
    final localFile = await File!.copy('${appDir.path}/$fileName');
    // SharedPreferencesに画像のパスを保存
    await pref.setString('imagePath', localFile.path);
    //}
  }

  Future<void> getSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> setImage() async {
    await getSharedPref();
    final String? imagePath = pref.getString('imagepath');
    if (imagePath != null) {
      imageFile = File(imagePath);
      //setState(() {});
    }
  }
}
//kotlinのverを1.7.0に変更(カメラ起動に関係する？)
