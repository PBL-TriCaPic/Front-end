// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SharedPrefs {
  static late SharedPreferences prefs;

  static Future<void> setInstance() async {
    prefs = await SharedPreferences.getInstance();
  } //OK　アイコン写真set　初期化

  static const String _profileImageKey = 'profileImage';

  // Base64エンコードされた画像をSharedPreferencesに保存
  static Future<void> setProfileImage(String base64Image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, base64Image);
    print("プロフィール写真をSharedPreferencesに保存しました  $base64Image");
  }

  // Base64エンコードされた画像をSharedPreferencesから取得
  static Future<String?> getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  static Future<String?> getImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferencesから画像のパスを取得
    return prefs.getString('imagePath');
  } //アイコン写真get OK

  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    print("ユーザー名をSharedPreferencesに保存しました");
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    print("ユーザーIDをSharedPreferencesに保存しました");
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> setMyBio(String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bio', bio);
    print("自己紹介文をSharedPreferencesに保存しました");
  }

  static Future<String?> getMyBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bio');
  }

  static Future<void> setEmail(String Email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Email', Email);
    print("EmailをSharedPreferencesに保存しました");
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Email');
  }

  static Future<void> setPassword(String Passward) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Password', Passward);
    print("PasswordをSharedPreferencesに保存しました");
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Password');
  }

  static Future<void> setCapsulesIdList(List<int> capsulesIdList) async {
    final prefs = await SharedPreferences.getInstance();
    // リストを文字列に変換して保存
    final jsonString = jsonEncode(capsulesIdList);
    await prefs.setString('capsulesIdList', jsonString);
    print("capsulesIdListをSharedPreferencesに保存しました");
  }

  static Future<List<int>> getCapsulesIdList() async {
    final prefs = await SharedPreferences.getInstance();
    // 文字列からリストに変換して取得
    final jsonString = prefs.getString('capsulesIdList');
    if (jsonString != null) {
      final dynamic decodedList = jsonDecode(jsonString);
      if (decodedList is List) {
        return List<int>.from(decodedList);
      }
    }
    return []; // デフォルト値を返す場合
  }

  static Future<void> setCapsulesLatList(List<double> capsulesLatList) async {
    final prefs = await SharedPreferences.getInstance();
    // リストを文字列に変換して保存
    final jsonString = jsonEncode(capsulesLatList);
    await prefs.setString('capsulesLatList', jsonString);
    print("capsulesLatnListをSharedPreferencesに保存しました");
  }

  static Future<List<double>> getCapsulesLatList() async {
    final prefs = await SharedPreferences.getInstance();
    // 文字列からリストに変換して取得
    final jsonString = prefs.getString('capsulesLatList');
    if (jsonString != null) {
      final dynamic LatList = jsonDecode(jsonString);
      if (LatList is List) {
        return List<double>.from(LatList);
      }
    }
    return []; // デフォルト値を返す場合
  }

  static Future<void> setCapsulesLonList(List<double> capsulesLonList) async {
    final prefs = await SharedPreferences.getInstance();
    // リストを文字列に変換して保存
    final jsonString = jsonEncode(capsulesLonList);
    await prefs.setString('capsulesLonList', jsonString);
    print("capsulesLonListをSharedPreferencesに保存しました");
  }

  static Future<List<double>> getCapsulesLonList() async {
    final prefs = await SharedPreferences.getInstance();
    // 文字列からリストに変換して取得
    final jsonString = prefs.getString('capsulesLonList');
    if (jsonString != null) {
      final dynamic LonList = jsonDecode(jsonString);
      if (LonList is List) {
        return List<double>.from(LonList);
      }
    }
    return []; // デフォルト値を返す場合
  }

//カメラで撮影した写真を保存する
  static Future<void> setTakeImage(XFile image) async {
    //awaitの記述は必須 readAsBytesSyncは使えないぽい
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    //写真をエンコードして、文字列をプリファレンスに保存
    print('${base64Image}関数');

    final imagepref = await SharedPreferences.getInstance();
    imagepref.setString('image', base64Image);
    //File aFile = File(image.path);
    //await saveImagePath(aFile);
  }

  //カプセルの中身を保存する
  static Future<void> setCapselText(String capsel_nakami) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('nakami', capsel_nakami);
  }

  //保存したカプセルの中身のテキストを呼び出す
  static Future<String?> getCapselText() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('nakami');
  }

  //エンコードした写真の文字列データを呼び出す
  static Future<String?> getTakeImage() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('image');
  }
}
