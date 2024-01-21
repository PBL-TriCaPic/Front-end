// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, unused_element

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Friend/Friend_List.dart';
import 'package:flutter_application_develop/src/Profile/Setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_setting/HTTP_request.dart';
import 'profile_edit.dart';
import '../theme_setting/Color_Scheme.dart';
import '../theme_setting/SharedPreferences.dart';
import 'dart:async';
import 'dart:convert';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  //File? imageFile;
  String? message = '画像';
  String? userName;
  String? userId;
  String? bio;
  int? friendCount;
  int? postsCount;
  List<String> capsulesIdList = [];
  List<double> capsuleLatList = [];
  List<double> capsuleLonList = [];

  Uint8List? decodedprofile;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

// タップ時にプロファイル画像を拡大表示するダイアログを表示
  void _showEnlargeDialog() async {
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
                backgroundImage: decodedprofile != null
                    ? Image.memory(decodedprofile!).image
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
  //}

  Future<void> _loadPreferences() async {
    final userNameValue = await SharedPrefs.getUsername();
    final userIdValue = await SharedPrefs.getUserId();
    final bioValue = await SharedPrefs.getMyBio();
    final capsulesIdListValue = await SharedPrefs.getCapsulesIdList();
    final capsulesLatListValue = await SharedPrefs.getCapsulesLatList();
    final capsulesLonListValue = await SharedPrefs.getCapsulesLonList();
    final capsulesCountValue = await SharedPrefs.getCapsulesCount();
    String? base64Image = await SharedPrefs.getProfileImage();
    print('Base64 Image: $base64Image'); // デバッグログ

    try {
      friendCount = await ApiService.fetchFriendsCount(userIdValue ?? '');
    } catch (e) {
      print('フレンド数の取得に失敗しました: $e');
    }

    // List<int> を List<String> に変換
    final capsulesIdListAsString =
        capsulesIdListValue.map((id) => id.toString()).toList();

    setState(() {
      userName = userNameValue;
      userId = userIdValue;
      bio = bioValue;
      capsulesIdList = capsulesIdListAsString;
      capsuleLatList = capsulesLatListValue.cast<double>();
      capsuleLonList = capsulesLonListValue.cast<double>();
      postsCount = capsulesCountValue ?? 0;
      if (base64Image != null) {
        decodedprofile = base64.decode(base64Image);
      } else {
        // imageDataがnullの場合の処理を行います（必要に応じて）。
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = lightTheme;
    return MaterialApp(
      theme: selectedTheme,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(''),
          elevation: 3,
          shadowColor: Colors.black,
        ),
        endDrawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userName ?? '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editProfile(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0), // Adjust the value as needed
                  child: Row(
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
                        children: [
                          const Text(
                            'カプセル数',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '$postsCount',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              // フレンドリスト画面に遷移
                              _navigateToFriendList(context);
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'フレンド数\n',
                                  ),
                                  TextSpan(
                                    text: '$friendCount',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  userId ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  bio ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // プロフィール編集画面に遷移する関数
  void _editProfile(BuildContext context) {
    _loadPreferences();
    //userName = prefs.getString('userName');
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          initialUserName: userName,
          initialUserID: userId,
          initialBio: bio,
        ),
      ),
    )
        .then((result) {
      setState(() {
        // 編集後、変更をSharedPreferencesに保存
        _loadPreferences();
      });
    });
  }

  void _navigateToFriendList(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendList(userId: userId),
      ),
    );

    _loadPreferences();
  }
}
