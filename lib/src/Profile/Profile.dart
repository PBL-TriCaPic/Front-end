import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Profile/Setting.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_edit.dart';
import '../theme_setting/Color_Scheme.dart';
import '../theme_setting/SharedPreferences.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  File? imageFile;
  String? message = '画像';
  String? userName;
  String? userId;
  String? bio;
  int? followingCount;
  int? followersCount;
  int? postsCount;

  @override
  void initState() {
    super.initState();
    // ユーザー統計情報のデフォルト値を初期化
    followingCount = 100;
    followersCount = 100;
    postsCount = 100;
    // ユーザーの設定をロードし、プロファイル画像を設定
    _loadPreferences();
    // 非同期で画像のパスを取得し、それが完了したら処理を行う
    Future.delayed(Duration.zero, () async {
      String? imagePath = await SharedPrefs.getImagePath();
      if (imagePath != null) {
        setState(() {
          imageFile = File(imagePath);
        });
      }
    });
    //setImage();
  }

  Future<void> _loadPreferences() async {
    setState(() async {
      userName = await SharedPrefs.getUsername();
      userId = await SharedPrefs.getUserId();
      bio = await SharedPrefs.getMyBio();
    });
  }

// タップ時にプロファイル画像を拡大表示するダイアログを表示
  void _showEnlargeDialog() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);

      setState(() {
        imageFile = image;
      });

      // 選択された画像を保存し、ステートを更新
      await SharedPrefs.setImage(imageFile!);
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
                  backgroundImage: FileImage(imageFile!),
                ),
              ),
            ),
          );
        },
      );
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
          title: const Text(''),
          elevation: 3,
          shadowColor: Colors.black,
        ),
        endDrawer: CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userName ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editProfile(context);
                    },
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(
                  onTap: () {
                    _showEnlargeDialog();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        imageFile != null ? FileImage(imageFile!) : null,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      '投稿',
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
                      'フォロワー',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$followersCount',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'フォロー数',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$followingCount',
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
            ],
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
  void _saveChanges(
    int? newFollowingCount,
    int? newFollowersCount,
    int? newPostsCount,
  ) async {
    if (newFollowingCount != null) {
      await prefs.setInt('followingCount', newFollowingCount);
    }
    if (newFollowersCount != null) {
      await prefs.setInt('followersCount', newFollowersCount);
    }
    if (newPostsCount != null) await prefs.setInt('postsCount', newPostsCount);

    _loadPreferences(); // 変更後の設定を再読み込み
  }
}
