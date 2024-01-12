// ignore_for_file: file_names, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_print

import 'dart:convert';
//import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/Color_Scheme.dart';
import '../Timeline/Timeline.dart';
//import '../theme_setting/SharedPreferences.dart';
import '../theme_setting/HTTP_request.dart';
import 'package:photo_view/photo_view.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class CapContentsScreen extends StatefulWidget {
  final String capsuleId;
  final String cityName;
  final String userName;
  final String userId;
  const CapContentsScreen({
    super.key,
    Key,
    required this.capsuleId,
    required this.cityName,
    required this.userName,
    required this.userId,
  });

  @override
  State<CapContentsScreen> createState() => _CapContentsScreenState();
}

class _CapContentsScreenState extends State<CapContentsScreen> {
  late SharedPreferences prefs;
  String? userName;
  String? userId;
  //File? imageFile;
  String? place;
  String? capsuleContent;

  String? capsuleDate;
  String? textData;
  String? imageData;

  String? profileimage;

  Uint8List? decodedImageData;
  Uint8List? decodedprofile;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _fetchCapsuleData(widget.capsuleId);
    print(widget.userName);
  }

  Future<void> _loadPreferences() async {
    // userName = userName;
    // userId = userId;
    //_loadImage();
  }

  // Future<void> _loadImage() async {
  //   String? base64Image = await SharedPrefs
  //       .getProfileImage(); //これはシェアドプリファレンスで画像を保存したものを持ってきてるだけ。
  //   //ここで
  //   setState(() {
  //     if (base64Image != null) {
  //       decodedprofile = base64.decode(base64Image);
  //     } else {
  //       // imageDataがnullの場合の処理を行います（必要に応じて）。
  //     }
  //   });
  // } //profile image  使わなくなるかも

  Future<void> _fetchCapsuleData(String capsuleId) async {
    try {
      final Map<String, dynamic> data =
          await ApiService.fetchCapsuleData(capsuleId);

      setState(() {
        //ここでプロフ画像も持ってくるからそれをデコードし、decodedprofileに代入する。
        capsuleDate = data['capsuleDate'];
        textData = data['textData'];
        place = widget.cityName;
        userName = widget.userName;
        userId = widget.userId;
        imageData = data['imageData'];
        profileimage = data['iconImage'];

        // imageDataがnullでない場合、Base64データをデコード
        if (profileimage != null) {
          decodedprofile = base64.decode(profileimage!);
        } else {
          // profileimageがnullの場合の処理を行います（必要に応じて）。
        }

        if (imageData != null) {
          decodedImageData = base64.decode(imageData!);
        } else {
          // imageDataがnullの場合の処理を行います（必要に応じて）。
        }
      });
      print('Capsule Data: $data');
    } catch (e) {
      print('Failed to load capsule data: $e');
    }
  }

  String formattedCapsuleDate() {
    if (capsuleDate == null) return '';
    DateTime dateTime = DateTime.parse(capsuleDate!);
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }

  void _showEnlargeDialog() {
    showDialog<void>(
      context: context,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // タップでダイアログを閉じる
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 1.8,
                // 画像を表示するロジックをここに追加
                backgroundImage: decodedprofile != null
                    ? MemoryImage(decodedprofile!)
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = lightTheme;
    return MaterialApp(
      theme: selectedTheme,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'assets/TriCaPic_logo.png',
            height: 200,
            width: 200,
          ),
          elevation: 3,
          shadowColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const TimelineScreen();
                }),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showEnlargeDialog();
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: decodedprofile != null
                            ? MemoryImage(decodedprofile!)
                            : null,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '埋めた日',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          formattedCapsuleDate(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          '場所',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          place ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  userId ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  textData ?? '', // 中身の表示
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                // imageDataがデコードされていれば、画像を表示
                if (decodedImageData != null)
                  SizedBox(
                    width: 500.0, // 任意の幅
                    height: 350.0, // 任意の高さ
                    child: PhotoView(
                      imageProvider: MemoryImage(decodedImageData!),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 0.6,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      enableRotation: true, // 画像の回転を有効にする
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
