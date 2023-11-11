import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Setting.dart';
import 'profile_edit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    _loadPreferences();
  }

  // SharedPreferencesからデータを読み込む関数
  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'ユーザー名';
      userID = prefs.getString('userID') ?? 'ユーザーID';
      bio = prefs.getString('bio') ?? 'ここに自己紹介文が入ります。ここに自己紹介文が入ります。';
      followingCount = prefs.getInt('followingCount') ?? 0;
      followersCount = prefs.getInt('followersCount') ?? 0;
      postsCount = prefs.getInt('postsCount') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    'https://pbs.twimg.com/media/FfHOaRIagAAxQlC.jpg',
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
          initialFollowingCount: followingCount,
          initialFollowersCount: followersCount,
          initialPostsCount: postsCount,
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
