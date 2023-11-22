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

class done extends StatelessWidget {
  const done(this.image, {Key? key}) : super(key: key);
  final XFile image;

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return Scaffold(
      body: Column(children: [
        Center(
          child: Image.file(
            File(image.path),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
        ),
        //画像をサーバにアップロード
        ElevatedButton(
            child: Text('アップロード'),
            onPressed: () async {
              //awaitの記述は必須 readAsBytesSyncは使えないぽい
              List<int> imageBytes = await image.readAsBytes();
              String base64Image = base64Encode(imageBytes);
              //サーバのURLを指定する
              Uri url = Uri.parse('');
              String body = json.encode({
                '撮影した画像.jpg?': base64Image,
              });
              /*画像をデコードして表示　ここに書くとimage.readAsBytes()がエラー
              Response response = await http.post(url, body: body);
              final picture_Data = json.decode(response.body);
              String imageBase64 = picture_Data['result'];
              Uint8List bytes = base64Decode(imageBase64);
              Image image = Image.memory(bytes);
              Image? picture_Return;
              picture_Return = image;*/
              /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return capsel_Create();
                },
              ),
            );*/
            }),

        //カプセル作成画面に遷移
        ElevatedButton(
          child: Text('次へ進む'),
          onPressed: () async {
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
}
//kotlinのverを1.7.0に変更(カメラ起動に関係する？)
