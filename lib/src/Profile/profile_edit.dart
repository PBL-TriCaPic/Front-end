import 'package:flutter/material.dart';
import '../theme_setting/SharedPreferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String? initialUserName; // Nullable
  final String? initialUserID; // Nullable
  final String? initialBio; // Nullable

  const EditProfileScreen({
    super.key,
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
          title: const Text('プロフィール編集'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
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
                const Text('ユーザー名'),
                TextField(controller: _userNameController),
                const SizedBox(height: 16),
                const Text('ユーザーID'),
                TextField(controller: _userIDController),
                const SizedBox(height: 16),
                const Text('自己紹介'),
                TextField(
                  controller: _bioController, maxLines: null, // または必要な行数
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ));
  }

  // 変更を保存する関数
  Future<void> _saveChanges(BuildContext context) async {
    // // 保存処理
    String? newUserName =
        _userNameController.text.isNotEmpty ? _userNameController.text : null;
    String? newUserID =
        _userIDController.text.isNotEmpty ? _userIDController.text : null;
    String? newBio =
        _bioController.text.isNotEmpty ? _bioController.text : null;
    if (newUserName != null) await SharedPrefs.setUsername(newUserName);
    if (newUserID != null) await SharedPrefs.setUserId(newUserID);
    if (newBio != null) await SharedPrefs.setMyBio(newBio);
    Navigator.of(context).pop({});
  }
}
