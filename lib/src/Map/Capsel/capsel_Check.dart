// ignore_for_file: file_names, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, camel_case_types, avoid_print, unnecessary_import

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_develop/src/Map/Capsel/capsel_Create.dart';
import 'package:flutter_application_develop/src/theme_setting/HTTP_request.dart';
import 'package:flutter_application_develop/src/theme_setting/SharedPreferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme_setting/Color_Scheme.dart';
//yamlにhttpを使用する記述を書く!
import 'package:shared_preferences/shared_preferences.dart';
import '../../Animation/Capsule_Filling_Animation.dart';
import '../Map.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class capsel_Check extends StatelessWidget {
  const capsel_Check({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const MyHomePage(title: 'Flutter Demo Home Page', nakami: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.nakami});

  final String title;
  final String nakami;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        capselLat = position.latitude;
        capselLon = position.longitude;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  late SharedPreferences pref;
  //String capsel_title = '';
  String? text_data;
  String? image_pref = '';
  String? userId;
  late double capselLat;
  late double capselLon;
  Uint8List? decode_Image;
  Image? picture_Return;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    pref = await SharedPreferences.getInstance();
    final userIdValue = await SharedPrefs.getUserId();
    final nakami = await SharedPrefs.getCapselText();
    image_pref = await SharedPrefs.getTakeImage();
    setState(() {
      userId = userIdValue;
      text_data = nakami;
      //final text_data = nakami;
      //ここでgetStringしないと中身nullになる
      //text_data = pref.getString('nakami');
      //撮影してエンコードした写真のデコード
      image_pref = image_pref;
      if (image_pref != null) {
        decode_Image = base64.decode(image_pref!);
      }

      final String? imagePath = pref.getString('imagepath');
      print('loadPref関数起動');
      if (imagePath != null) {
        imageFile = File(imagePath);
      }
      //final image = File(imageFile!.path);
    });
  }

  // Future<void> _showConfirmationDialog() async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('注意'),
  //         content: const Text('以下の内容で埋めてもよろしいですか？'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // ダイアログを閉じる
  //               _onPressedFunction(); // ボタンの処理を実行
  //             },
  //             child: const Text('OK'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // ダイアログを閉じる
  //             },
  //             child: const Text('キャンセル'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Future<void> _showConfirmationDialog() async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('注意'),
            content: const Text('戻るとカプセルの文章が破棄されてしまいます\n本当に戻りますか？'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      // カプセル作成画面に遷移
                      return const capsel_Create();
                    }),
                  ); // ダイアログを閉じる
                  //_onPressedFunction(); // ボタンの処理を実行
                },
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ダイアログを閉じる
                },
                child: const Text('キャンセル'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _onPressedFunction() async {
      screenTransitionAnimation(context, () {
        print("transition started");
        Navigator.of(context).push(_createRoute());
      });
      //final AudioPlayer _audioPlayer = AudioPlayer();
      await getCurrentLocation(); // 位置情報を取得
      final userData = await ApiService.capselSend(
          text_data, capselLat, capselLon, userId, image_pref!);
      //String mp3Url = "assets/Capsule_digging.mp3"; // 実際のURLまたはローカルパスに置き換えてください
      //await _audioPlayer.play(Uri.parse(mp3Url) as Source);
      final List<int> capsulesIdListnew =
          List<int>.from(userData['capsulesIdList'] ?? []);
      final List<double> capsulesLatListnew =
          List<double>.from(userData['capsuleLatList'] ?? []);
      final List<double> capsulesLonListnew =
          List<double>.from(userData['capsuleLonList'] ?? []);
      await SharedPrefs.setCapsulesIdList(capsulesIdListnew);
      await SharedPrefs.setCapsulesLatList(capsulesLatListnew);
      await SharedPrefs.setCapsulesLonList(capsulesLonListnew);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('カプセル確認'),
        //backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  child: const Text(
                    '戻る',
                    style: TextStyle(
                      fontSize: 18, // フォントサイズの設定
                      //fontWeight: FontWeight.bold, // 太文字の設定
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _onPressedFunction,
                  child: const Text(
                    '埋める！',
                    style: TextStyle(
                      fontSize: 18, // フォントサイズの設定
                      fontWeight: FontWeight.bold, // 太文字の設定
                    ),
                  ),
                ),
              ],
            ),
            Column(
              // 縦並び
              children: <Widget>[
                const Text('-中身-'),
                SelectableText(
                  text_data ?? 'テキストは空です',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('-写真-'),
                Image.memory(decode_Image!),
                const Text("以下の内容で埋めてもよろしいですか？"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 1),
      pageBuilder: ((context, animation, secondaryAnimation) =>
          const MapScreen()),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var tween =
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.linear));
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      });
}
