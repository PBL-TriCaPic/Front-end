// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Uint8List? decodedprofile;
  String? base64Image;
  bool hasImageChanged = false;

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
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    String? base64Image = await SharedPrefs.getProfileImage();
    //print('Base64 Image: $base64Image'); // デバッグログ
    setState(() {
      if (base64Image != null) {
        decodedprofile = base64.decode(base64Image);
      } else {
        // imageDataがnullの場合の処理を行います（必要に応じて）。
      }
    });
  }

  void _showEnlargeDialog() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);

      // 画像をBase64文字列にエンコード
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);

      // 選択された画像を保存し、ステートを更新
      setState(() {
        decodedprofile = imageBytes as Uint8List?;
        hasImageChanged = true;
      });

      // 拡大表示されたプロファイル画像を含むダイアログを表示

      // _saveChangesメソッドを呼び出す
      //_saveChanges(context);
    }
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
                //Navigator.of(context).pop();
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
                Center(
                  child: GestureDetector(
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
                ),
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

      if (hasImageChanged) {
        await SharedPrefs.setProfileImage(base64Image!);
      }
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
