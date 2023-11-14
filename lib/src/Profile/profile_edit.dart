import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class EditProfileScreen extends StatefulWidget {
  final String? initialUserName; // Nullable
  final String? initialUserID; // Nullable
  final String? initialBio; // Nullable
  //final int? initialFollowingCount; // Nullable
  //final int? initialFollowersCount; // Nullable
  //final int? initialPostsCount; // Nullable

  EditProfileScreen({
    this.initialUserName,
    this.initialUserID,
    this.initialBio,
    //this.initialFollowingCount,
    //this.initialFollowersCount,
    //this.initialPostsCount,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _userIDController;
  late TextEditingController _bioController;
  // late TextEditingController _followingController;
  // late TextEditingController _followersController;
  // late TextEditingController _postsController;

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.initialUserName ?? '');
    _userIDController = TextEditingController(text: widget.initialUserID ?? '');
    _bioController = TextEditingController(text: widget.initialBio ?? '');
    // _followingController = TextEditingController(
    //     text: widget.initialFollowingCount?.toString() ?? '');
    // _followersController = TextEditingController(
    //     text: widget.initialFollowersCount?.toString() ?? '');
    // _postsController =
    //     TextEditingController(text: widget.initialPostsCount?.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('プロフィール編集'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                // 保存ボタンが押されたときの処理
                _saveChanges(context);
              },
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(null);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ユーザー名'),
                TextField(controller: _userNameController),
                SizedBox(height: 16),
                Text('ユーザーID'),
                TextField(controller: _userIDController),
                SizedBox(height: 16),
                Text('自己紹介'),
                TextField(
                  controller: _bioController, maxLines: null, // または必要な行数
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 16),
                // Text('フォロー数'),
                // TextField(controller: _followingController),
                // SizedBox(height: 16),
                // Text('フォロワー数'),
                // TextField(controller: _followersController),
                // SizedBox(height: 16),
                // Text('投稿数'),
                // TextField(controller: _postsController),
              ],
            ),
          ),
        ));
  }

  // 変更を保存する関数
  void _saveChanges(BuildContext context) {
    // 保存処理
    String? newUserName =
        _userNameController.text.isNotEmpty ? _userNameController.text : null;
    String? newUserID =
        _userIDController.text.isNotEmpty ? _userIDController.text : null;
    String? newBio =
        _bioController.text.isNotEmpty ? _bioController.text : null;
    // int? newFollowingCount = int.tryParse(_followingController.text);
    // int? newFollowersCount = int.tryParse(_followersController.text);
    // int? newPostsCount = int.tryParse(_postsController.text);

    // プロフィール編集画面からデータを元の画面に渡す
    Navigator.of(context).pop({
      'userName': newUserName,
      'userID': newUserID,
      'bio': newBio,
      // 'followingCount': newFollowingCount,
      // 'followersCount': newFollowersCount,
      // 'postsCount': newPostsCount,
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userIDController.dispose();
    _bioController.dispose();
    // _followingController.dispose();
    // _followersController.dispose();
    // _postsController.dispose();
    super.dispose();
  }
}
