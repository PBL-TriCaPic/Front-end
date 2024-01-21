// ignore_for_file: use_build_context_synchronously, unnecessary_import, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PictureCheck extends StatelessWidget {
  PictureCheck(this.image, {super.key});
  final XFile image;
  late SharedPreferences pref;
  File? image_File;

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    return Scaffold(
      body: Column(children: [
        Center(
          child: Image.file(
            //撮影した画像を表示
            File(image.path),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
        ),
        //画像をサーバにアップロード

        //カプセル作成画面に遷移
        ElevatedButton(
          child: const Text('次へ進む'),
          onPressed: () async {
            await SharedPrefs.setTakeImage(image);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const capsel_Create();
                },
              ),
            );
          },
        ),
        ElevatedButton(
          child: const Text('撮りなおす'),
          onPressed: () async {
            //カメラ撮影画面に遷移
            final XFile? image = await picker.pickImage(
              source: ImageSource.camera,
            );
            if (image != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PictureCheck(image),
                ),
              );
            }
          },
        ),
      ]),
    );
  }
}
//kotlinのverを1.7.0に変更(カメラ起動に関係する？)
