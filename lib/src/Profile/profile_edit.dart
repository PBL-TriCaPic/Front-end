import 'package:flutter/material.dart';
import '../theme_setting/SharedPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme_setting/HTTP_request.dart';
//import 'package:shared_preferences/shared_preferences.dart';

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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = ''; //簡易ログイン

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
            Text(message),
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
                // const Text('メールアドレス'),
                // TextField(controller: emailController),
                // const SizedBox(height: 16),
                // const Text('パスワード'),
                // TextField(controller: passwordController),
                // const SizedBox(height: 16),
              ],
            ),
          ),
        ));
  }

  // 変更を保存する関数
  Future<void> _saveChanges(BuildContext context) async {
    // // 保存処理
    try {
      // final email = emailController.text;
      // final password = passwordController.text;
      // final userData = await ApiService.loginUser(email, password);
      // await SharedPrefs.setEmail(email);
      // await SharedPrefs.setPassword(password);
      String? newBio =
          _bioController.text.isNotEmpty ? _bioController.text : null;
      // if (newUserName != null)
      // await SharedPrefs.setUsername(userData['username']);
      // // if (newUserID != null)
      // await SharedPrefs.setUserId(userData['userId']);
      if (newBio != null) await SharedPrefs.setMyBio(newBio);

      //final List<int> capsulesIdList =
      //     List<int>.from(userData['capsulesIdList'] ?? []);
      // final List<double> capsulesLatList =
      //     List<double>.from(userData['capsuleLatList'] ?? []);
      // final List<double> capsulesLonList =
      //     List<double>.from(userData['capsuleLonList'] ?? []);
      // await SharedPrefs.setCapsulesIdList(capsulesIdList);
      // await SharedPrefs.setCapsulesLatList(capsulesLatList);
      // await SharedPrefs.setCapsulesLonList(capsulesLonList);
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        message = 'Login failed. Please check your credentials.';
      });
    }
  }
}
