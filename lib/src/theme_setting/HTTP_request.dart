// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseApiUrl = 'http://172.20.10.9:8081/api';

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final List<int> bytes = response.bodyBytes;
      final userData = jsonDecode(utf8.decode(bytes));
      return userData;
    } else {
      throw Exception('ログインに失敗しました。資格情報を確認してください。');
    }
  } //login

  static Future<bool> createUser(
      String userID, String email, String password, String name) async {
    final url = Uri.parse('$baseApiUrl/create/user');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userID,
      'email': email,
      'password': password,
      'name': name,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('POSTリクエストが成功しました');
      print('サーバーレスポンス: ${response.body}'); // サーバーレスポンスをログに表示
      return response.body == 'true';
    } else {
      throw Exception('Failed to create user');
    }
  } //signup

  static Future<Map<String, dynamic>> fetchCapsuleData(String capsuleId) async {
    final response = await http.get(
      Uri.parse('$baseApiUrl/get/capsules/$capsuleId'),
    );

    if (response.statusCode == 200) {
      final List<int> bytes = response.bodyBytes;
      final Map<String, dynamic> capsuleData = jsonDecode(utf8.decode(bytes));
      return capsuleData;
    } else {
      throw Exception(
          'Failed to load capsule data. Status code: ${response.statusCode}');
    }
  } //カプセル参照

  static Future<Map<String, dynamic>> capselSend(
      String? textData,
      double capselLat,
      double capselLon,
      String? userId,
      String? imagePref) async {
    final url = Uri.parse('$baseApiUrl/create/capsule');
    final headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> requestBody = {
      'textData': textData,
      'capsuleLat': capselLat.toString(),
      'capsuleLon': capselLon.toString(),
      'userId': userId,
      'imageDataBase64': imagePref,
    };

    final String encodedBody = json.encode(requestBody);
    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        print('カプセル内容のPOSTリクエスト成功');
        print('サーバーレスポンスは：${response.body}です');
        //print('あああ${encodedBody}');
        final List<int> bytes = response.bodyBytes;
        final Map<String, dynamic> capsuleData = jsonDecode(utf8.decode(bytes));
        return capsuleData;
      } else {
        print('サーバに送るのを失敗しました。HTTPステータスコード: ${response.statusCode}');
        print('サーバーレスポンスは：${response.body}です');
        throw Exception('サーバに送るのを失敗しました。');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      throw Exception('サーバに送るのを失敗しました。');
    }
  } //カプセル埋める

  static Future<bool> updateUserInformation(
    String userId,
    String iconImageBase64,
    String name,
    String profile,
  ) async {
    final url = Uri.parse('$baseApiUrl/update/userInf');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userId,
      'iconImage': iconImageBase64,
      'name': name,
      'profile': profile,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('ユーザー情報の更新に成功しました');
        print('サーバーレスポンス: ${response.body}');

        return response.body == 'true';
      } else {
        print('ユーザー情報の更新に失敗しました。HTTPステータスコード: ${response.statusCode}');
        print('サーバーレスポンス: ${response.body}');
        throw Exception('ユーザー情報の更新に失敗しました');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      throw Exception('ユーザー情報の更新に失敗しました');
    }
  } //プロフィール更新

  static Future<List<dynamic>> fetchFriendsList(String userId) async {
    final url = Uri.parse('$baseApiUrl/relations/get/friends-list/$userId');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<int> bytes = response.bodyBytes;
        final List<dynamic> friendsList = jsonDecode(utf8.decode(bytes));
        return friendsList;
      } else {
        print('友達リストの取得に失敗しました。HTTPステータスコード: ${response.statusCode}');
        print('サーバーレスポンス: ${response.body}');
        throw Exception('友達リストの取得に失敗しました');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      throw Exception('友達リストの取得に失敗しました');
    }
  } //フレンドリストの取得

  static Future<int> fetchFriendsCount(String userId) async {
    final url = Uri.parse('$baseApiUrl/relations/get/friends-count/$userId');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final int friendsCount = int.parse(response.body); // 変更点
        return friendsCount;
      } else {
        print('フレンド数の取得に失敗しました。HTTPステータスコード: ${response.statusCode}');
        print('サーバーレスポンス: ${response.body}');
        throw Exception('フレンド数の取得に失敗しました');
      }
    } catch (e) {
      print('エラーが発生しました: $e');
      throw Exception('フレンド数の取得に失敗しました');
    } //フレンド数取得
  }
}
