import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Setting.dart';
import 'profile_edit.dart';
import '../theme_setting/Color_Scheme.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';

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
  late File _image = File('');
  // ユーザー名、ユーザID、自己紹介文、フォロー数、フォロワー数、投稿数の変数を追加
  String? userName; // 変更
  String? userID; // 変更
  String? bio; // 変更
  int? followingCount; // 変更
  int? followersCount; // 変更
  int? postsCount; // 変更

  @override
  void initState() {
    super.initState();
    followingCount = 100; // 初期化をここで行う
    followersCount = 100; // 初期化をここで行う
    postsCount = 100; // 初期化をここで行う
    _loadPreferences();
  }

  // SharedPreferencesからデータを読み込む関数
  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'ユーザー名';
      userID = prefs.getString('userID') ?? 'ユーザーID';
      bio = prefs.getString('bio') ?? 'ここに自己紹介文が入ります。ここに自己紹介文が入ります。';
      // followingCount = prefs.getInt('followingCount') ?? followingCount;
      // followersCount = prefs.getInt('followersCount') ?? followersCount;
      // postsCount = prefs.getInt('postsCount') ?? postsCount;
    });
  }

  Future<CroppedFile?> _cropImage(File imageFile) async {
    final imageCropper = ImageCropper(); // ImageCropper クラスのインスタンスを作成
    CroppedFile? croppedFile = await imageCropper
        .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: '画像を切り抜く',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: '画像を切り抜く',
      ),
    ]);

    return croppedFile;
  }

// 画像を拡大表示するためのダイアログを表示する関数
  void _showEnlargeDialog() async {
    // 画像を選択する
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // 選択された画像を切り抜く
      File? croppedFile = (await _cropImage(File(pickedFile.path))) as File?;

      if (croppedFile != null) {
        setState(() {
          _image = croppedFile;
        });

        // 切り抜かれた画像をアプリ内に保存
        await _saveImage(_image);

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
                    backgroundImage: FileImage(_image),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _saveImage(File imageFile) async {
    // 切り抜かれた画像をアプリ内に保存（必要に応じてパスを変更）
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'profile_image.jpg';
    final localFile = await imageFile.copy('${appDir.path}/$fileName');

    // SharedPreferencesなどを使用して、画像のパスや必要な情報を保存することもできます。
    // 例えば、prefs.setString('imagePath', localFile.path);
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
                  Spacer(), // 中間に空白を挿入
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
                        _image.existsSync() ? FileImage(_image) : null,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '投稿',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$postsCount', // 投稿数を表示
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
                      '$followersCount', // 投稿数を表示
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
// 投稿数を表示
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
                bio ?? '', // 自己紹介文を表示
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
    userName = prefs.getString('userName'); // 変更
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          initialUserName: userName,
          initialUserID: userID,
          initialBio: bio,
          // initialFollowingCount: followingCount,
          // initialFollowersCount: followersCount,
          // initialPostsCount: postsCount,
        ),
      ),
    )
        .then((result) {
      // 編集画面から戻ったときの処理
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

  // 変更を保存する関数
  void _saveChanges(
    String? newUserName,
    String? newUserID,
    String? newBio,
    int? newFollowingCount,
    int? newFollowersCount,
    int? newPostsCount,
  ) async {
    // 保存処理
    if (newUserName != null) await prefs.setString('userName', newUserName);
    if (newUserID != null) await prefs.setString('userID', newUserID);
    if (newBio != null) await prefs.setString('bio', newBio);
    if (newFollowingCount != null)
      await prefs.setInt('followingCount', newFollowingCount);
    if (newFollowersCount != null)
      await prefs.setInt('followersCount', newFollowersCount);
    if (newPostsCount != null) await prefs.setInt('postsCount', newPostsCount);

    // SharedPreferencesからデータを読み込み、UIを更新
    _loadPreferences();
  }
}
