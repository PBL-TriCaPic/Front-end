import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String? initialUserName; // Nullable
  final String? initialUserID; // Nullable
  final String? initialBio; // Nullable

  EditProfileScreen({
    this.initialUserName,
    this.initialUserID,
    this.initialBio,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _userIDController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _userNameController =
        TextEditingController(text: widget.initialUserName ?? '');
    _userIDController = TextEditingController(text: widget.initialUserID ?? '');
    _bioController = TextEditingController(text: widget.initialBio ?? '');
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

    // プロフィール編集画面からデータを元の画面に渡す
    Navigator.of(context).pop({
      'userName': newUserName,
      'userID': newUserID,
      'bio': newBio,
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userIDController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
