import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme_setting/HTTP_request.dart';
import '../theme_setting/SharedPreferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String? initialUserName;
  final String? initialUserID;
  final String? initialBio;

  const EditProfileScreen({
    Key? key,
    this.initialUserName,
    this.initialUserID,
    this.initialBio,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _bioController;

  Uint8List? decodedprofile;
  String? base64Image;
  bool hasImageChanged = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String message = '';
  late String userID; // 修正

  @override
  void initState() {
    super.initState();
    userID = widget.initialUserID!;
    _userNameController =
        TextEditingController(text: widget.initialUserName ?? '');
    _bioController = TextEditingController(text: widget.initialBio ?? '');
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    String? base64Image = await SharedPrefs.getProfileImage();
    setState(() {
      if (base64Image != null) {
        decodedprofile = base64.decode(base64Image);
      }
    });
  }

  void _showEnlargeDialog() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);

      setState(() {
        decodedprofile = imageBytes as Uint8List?;
        hasImageChanged = true;
      });
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    userID,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              const Text('自己紹介'),
              TextField(
                controller: _bioController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    final username = _userNameController.text;
    String? newBio =
        _bioController.text.isNotEmpty ? _bioController.text : null;

    await ApiService.updateUserInformation(
        userID, base64Image ?? '', username, newBio ?? '');
    await SharedPrefs.setMyBio(newBio!);
    await SharedPrefs.setUsername(username);

    if (hasImageChanged) {
      await SharedPrefs.setProfileImage(base64Image!);
    }

    Navigator.of(context).pop();
  }
}
