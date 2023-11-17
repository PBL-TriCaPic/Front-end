import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SharedPrefs {
  static late SharedPreferences prefs;

  static Future<void> setInstance() async {
    prefs = await SharedPreferences.getInstance();
  } //OK　アイコン写真set　初期化

  static Future<SharedPreferences> getSharedPreference() async {
    return await SharedPreferences.getInstance();
  } //OK アイコン写真get　初期化

  static Future<void> setImage(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    // 切り抜かれた画像をアプリ内に保存（必要に応じてパスを変更）
    final appDir = await getApplicationDocumentsDirectory();
    const fileName = 'profile_image.jpg';
    final localFile = await imageFile.copy('${appDir.path}/$fileName');
    // SharedPreferencesに画像のパスを保存
    await prefs.setString('imagePath', localFile.path);
    print("アイコン写真をSharedPreferencesに保存しました");
  } // 選択した画像をアプリの内部ストレージとSharedPreferencesに保存 0K

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
}
