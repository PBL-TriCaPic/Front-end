import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Profile/Setting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/Color_Scheme.dart';
import '../Timeline/Timeline.dart';
import '../theme_setting/SharedPreferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class CapContentsScreen extends StatelessWidget {
  const CapContentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: CapContentsPage(),
    );
  }
}

class CapContentsPage extends StatefulWidget {
  @override
  State<CapContentsPage> createState() => _CapContentsPageState();
}

class _CapContentsPageState extends State<CapContentsPage> {
  late SharedPreferences prefs;
  String? userName;
  String? userId;
  File? imageFile;
  String date = '2月22日';
  String place = '函館市';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    userName = await SharedPrefs.getUsername();
    userId = await SharedPrefs.getUserId();
    _loadImage();
  }

  Future<void> _loadImage() async {
    prefs = await SharedPrefs.getSharedPreference(); // prefs を初期化
    final String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      imageFile = File(imagePath);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = lightTheme;
    return MaterialApp(
        theme: selectedTheme,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('タイムカプセル中身'),
              elevation: 3,
              shadowColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      //カプセル作成画面に遷移
                      return TimelineScreen();
                    }),
                  ); // ボタンが押された時の処理
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile!)
                                : null,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center, // ここを追加
                          children: [
                            Text(
                              '埋めた日',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '$date',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '場所',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              '$place',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ]),
                  // 利用可能な場合は画像を表示
                  SizedBox(height: 16),
                  Text(
                    userId ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )));
  }
}
