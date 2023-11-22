import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/Color_Scheme.dart';
import '../Timeline/Timeline.dart';
import '../theme_setting/SharedPreferences.dart';
import '../theme_setting/HTTP_request.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class CapContentsScreen extends StatefulWidget {
  final String capsuleId;
  final String cityName;
  const CapContentsScreen(
      {super.key, required this.capsuleId, required this.cityName});

  @override
  State<CapContentsScreen> createState() => _CapContentsScreenState();
}

class _CapContentsScreenState extends State<CapContentsScreen> {
  late SharedPreferences prefs;
  String? userName;
  String? userId;
  File? imageFile;
  String? place;
  String? capsuleContent;

  String? capsuleDate;
  String? textData;
  String? imageData;
  //String? cityName;

  Uint8List? decodedImageData;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _fetchCapsuleData(widget.capsuleId);
  }

  Future<void> _loadPreferences() async {
    userName = await SharedPrefs.getUsername();
    userId = await SharedPrefs.getUserId();
    _loadImage();
  }

  Future<void> _loadImage() async {
    prefs = await SharedPrefs.getSharedPreference();
    final String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      imageFile = File(imagePath);
      setState(() {});
    }
  }

  Future<void> _fetchCapsuleData(String capsuleId) async {
    try {
      final Map<String, dynamic> data =
          await ApiService.fetchCapsuleData(capsuleId);

      setState(() {
        capsuleDate = data['capsuleDate'];
        textData = data['textData'];
        place = widget.cityName;
        imageData = data['imageData'];
        // imageDataがnullでない場合、Base64データをデコード
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
                  return TimelineScreen();
                }),
              );
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
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile!) : null,
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
              SizedBox(height: 16),
              Text(
                userId ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                textData ?? '', // 中身の表示
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              // imageDataがデコードされていれば、画像を表示
              if (decodedImageData != null)
                Center(
                  child: Image.memory(
                    decodedImageData!,
                    width: MediaQuery.of(context).size.width *
                        0.9, // Set width to 90% of device width
                    //height: MediaQuery.of(context).size.width * 0.9
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
