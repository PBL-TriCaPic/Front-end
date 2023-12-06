// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
<<<<<<< HEAD
  static const String baseApiUrl = 'http://10.0.2.2:8081/api';
=======
  static const String baseApiUrl = 'http://10.124.50.73:8081/api';
>>>>>>> 3db766c7ab19c1a6e5b5eb953344791abe4cf65b

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
}
