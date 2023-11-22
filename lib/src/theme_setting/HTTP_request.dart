import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.10.119:8081/api/login'), //エミュレータは　10.0.2.2
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
  } //ログイン

  static Future<Map<String, dynamic>> fetchCapsuleData(String capsuleId) async {
    final response = await http.get(
      Uri.parse('http://192.168.10.119:8081/api/get/capsules/$capsuleId'),
    );

    if (response.statusCode == 200) {
      final List<int> bytes = response.bodyBytes;
      final Map<String, dynamic> capsuleData =
          jsonDecode(utf8.decode(bytes)); //
      return capsuleData; //
    } else {
      throw Exception(
          'Failed to load capsule data. Status code: ${response.statusCode}');
    }
  } //カプセルget
}
