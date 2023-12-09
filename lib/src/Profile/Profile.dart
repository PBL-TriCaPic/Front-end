// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously, avoid_print, unused_element

//import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Profile/Setting.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_edit.dart';
import '../theme_setting/Color_Scheme.dart';
import '../theme_setting/SharedPreferences.dart';
import 'dart:async';
//import '../Timeline/TimlineButton.dart';
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
  int? followingCount;
  int? followersCount;
  int? friendCount;
  int? postsCount;
  List<String> capsulesIdList = [];
  List<double> capsuleLatList = [];
  List<double> capsuleLonList = [];

  Uint8List? decodedprofile;

  @override
  void initState() {
    super.initState();
    // ユーザー統計情報のデフォルト値を初期化
    // followingCount = 100;
    // followersCount = 100;
    friendCount = 100;
    postsCount = 100;
    // ユーザーの設定をロードし、プロファイル画像を設定
    _loadPreferences();
  }

// タップ時にプロファイル画像を拡大表示するダイアログを表示
  void _showEnlargeDialog() async {
    // final pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);

    //if (pickedFile != null) {
    //final image = File(pickedFile.path);

    // 画像をBase64文字列にエンコード
    //List<int> imageBytes = await image.readAsBytes();
    //String base64Image = base64Encode(imageBytes);

    // Base64エンコードされた画像をSharedPreferencesに保存
    //await SharedPrefs.setProfileImage(base64Image);

    await _loadPreferences();

    // setState(() {
    //   decodedprofile = base64Image as Uint8List?;
    // });

    // 選択された画像を保存し、ステートを更新
    //await SharedPrefs.setImage(imageFile!);
    // 拡大表示されたプロファイル画像を含むダイアログを表示
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
    String? base64Image = await SharedPrefs.getProfileImage();
    print('Base64 Image: $base64Image'); // デバッグログ
    // if (base64Image != null) {
    //   List<int> imageBytes = base64Decode(base64Image);
    //   print('デコードされた画像バイト: $imageBytes');
    //   Uint8List imageData = Uint8List.fromList(imageBytes);
    //   //print('Base64 Image: $base64Image'); // デバッグログ
    //   setState(() {
    //     imageFile = File.fromRawPath(imageData);
    //   });
    // }

    // List<int> を List<String> に変換
    final capsulesIdListAsString =
        capsulesIdListValue.map((id) => id.toString()).toList();

    // print('userName: $userNameValue');
    // print('userId: $userIdValue');
    // print('bio: $bioValue');
    // print('capsulesIdList: $capsulesIdListValue');
    // print('capsulesLatList: $capsulesLatListValue');
    // print('capsulesLonList: $capsulesLonListValue');
    setState(() {
      userName = userNameValue;
      userId = userIdValue;
      bio = bioValue;
      capsulesIdList = capsulesIdListAsString;
      capsuleLatList = capsulesLatListValue.cast<double>();
      capsuleLonList = capsulesLonListValue.cast<double>();
      if (base64Image != null) {
        decodedprofile = base64.decode(base64Image);
      } else {
        // imageDataがnullの場合の処理を行います（必要に応じて）。
      }
    });
  }

  // Widget _buildImageWidget() {
  //   return imageFile != null
  //       ? Image.memory(
  //           Uint8List.fromList(imageFile!.readAsBytesSync()),
  //           height: 100, // 画像の高さを適切に設定
  //           width: 100, // 画像の幅を適切に設定
  //         )
  //       : Container(); // 画像がない場合は空のContainerを表示
  // }

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
                          // child: Image.memory(
                          //   Uint8List.fromList(imageFile!.readAsBytesSync()),
                          //   height: 100,
                          //   width: 100,
                          // ),
                        ),
                      ),
                      Column(
                        children: [
                          const Text(
                            '投稿数',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '$postsCount',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'フレンド数',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '$friendCount',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
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

  // 変更をSharedPreferencesに保存する関数(フォローフォロワー投稿数)
  // void _saveChanges(
  //   int? newFollowingCount,
  //   int? newFollowersCount,
  //   int? newPostsCount,
  // ) async {
  //   if (newFollowingCount != null) {
  //     await prefs.setInt('followingCount', newFollowingCount);
  //   }
  //   if (newFollowersCount != null) {
  //     await prefs.setInt('followersCount', newFollowersCount);
  //   }
  //   if (newPostsCount != null) await prefs.setInt('postsCount', newPostsCount);

  //   _loadPreferences(); // 変更後の設定を再読み込み
  // }
}
