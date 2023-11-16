import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Profile/Setting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_edit.dart';
import '../theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  File? imageFile;
  String? message = '画像';
  String? userName;
  String? userID;
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
    setImage();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'ユーザー名';
      userID = prefs.getString('userID') ?? 'ユーザーID';
      bio = prefs.getString('bio') ?? 'ここに自己紹介文が入ります。';
    });
  }

// タップ時にプロファイル画像を拡大表示するダイアログを表示
  void _showEnlargeDialog() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);

      // 選択された画像を保存し、ステートを更新
      await _saveImage(image);

      setState(() {
        imageFile = image;
      });
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

// 選択した画像をアプリの内部ストレージとSharedPreferencesに保存
  Future<void> _saveImage(File imageFile) async {
    // 切り抜かれた画像をアプリ内に保存（必要に応じてパスを変更）
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_image.jpg';
    final localFile = await imageFile.copy('${appDir.path}/$fileName');
    // SharedPreferencesに画像のパスを保存
    await prefs.setString('imagePath', localFile.path);
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
                    Text(
                      '投稿',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$postsCount',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'フォロワー',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$followersCount',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'フォロー数',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$followingCount',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 16),
              Text(
                userID ?? '',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                bio ?? '',
                style: TextStyle(fontSize: 16),
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
    userName = prefs.getString('userName');
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          initialUserName: userName,
          initialUserID: userID,
          initialBio: bio,
        ),
      ),
    )
        .then((result) {
      // 編集後、変更をSharedPreferencesに保存
      if (result != null && result is Map<String, dynamic>) {
        _saveChanges(
          result['userName'],
          result['userID'],
          result['bio'],
          result['followingCount'],
          result['followersCount'],
          result['postsCount'],
        );
      }
    });
  }

  // 変更をSharedPreferencesに保存する関数
  void _saveChanges(
    String? newUserName,
    String? newUserID,
    String? newBio,
    int? newFollowingCount,
    int? newFollowersCount,
    int? newPostsCount,
  ) async {
    if (newUserName != null) await prefs.setString('userName', newUserName);
    if (newUserID != null) await prefs.setString('userID', newUserID);
    if (newBio != null) await prefs.setString('bio', newBio);
    if (newFollowingCount != null)
      await prefs.setInt('followingCount', newFollowingCount);
    if (newFollowersCount != null)
      await prefs.setInt('followersCount', newFollowersCount);
    if (newPostsCount != null) await prefs.setInt('postsCount', newPostsCount);

    _loadPreferences(); // 変更後の設定を再読み込み
  }

// プロファイル画像を設定する関数
  Future<void> setImage() async {
    await getSharedPreference();
    final String? imagePath = prefs.getString('imagePath');
    if (imagePath != null) {
      imageFile = File(imagePath);
      setState(() {});
    }
  }

// SharedPreferencesを取得する関数
  Future<void> getSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }
}
