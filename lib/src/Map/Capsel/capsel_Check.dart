import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/app.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme_setting/Color_Scheme.dart';

class Sample2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('カプセル確認画面'),
        //backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(//縦並び
          children: <Widget>[
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                //マップ画面に遷移(Navigatorpopの方がいいかも？)
                return capsel_Create();
              }),
            );
          },
          child: Text('戻る'),
        ),
        OutlinedButton(
          onPressed: () {
            //カプセルを埋める画面に遷移
          },
          child: Text('埋める！'),
        ),
      ]),
    );
  }
}
