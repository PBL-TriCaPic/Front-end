import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Map.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:image_picker/image_picker.dart';

class done extends StatelessWidget {
  const done(this.image, {Key? key}) : super(key: key);
  final XFile image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.file(
              File(image.path),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text('画像が選択されました!'),
          ),
          ElevatedButton(
            child: Text('完了'),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MapScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
//kotlinのverを1.7.0に変更(カメラ起動に関係する？)
