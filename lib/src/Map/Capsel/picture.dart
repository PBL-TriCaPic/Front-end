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
  File? image_File;

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
            //await saveImagePath(aFile);
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

  /*Future<void> saveImagePath(File File) async {
    getSharedPref();
    //if (image != null) {
    //await pref.setString('imagepath', image!.path);
    //setState(() {});
    final app_Dir = await getApplicationDocumentsDirectory();
    const file_Name = 'profile_image.jpg';
    final local_File = await File!.copy('${app_Dir.path}/$file_Name');
    // SharedPreferencesに画像のパスを保存
    await pref.setString('imagepath', local_File.path);
    //}
  }*/

  Future<void> getSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> setTakeImage() async {
    await getSharedPref();
    final String? image_Path = pref.getString('imagepath');
    if (image_Path != null) {
      image_File = File(image_Path);
      //setState(() {});
    }
  }
}
//kotlinのverを1.7.0に変更(カメラ起動に関係する？)
