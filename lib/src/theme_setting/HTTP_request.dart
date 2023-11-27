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

  //カプセル内容送信
  static Future<Map<String, dynamic>> capselSend(
      String? text_Data,
      double capselLat,
      double capselLon,
      String? userId,
      String? image_pref) async {
    final url = Uri.parse('http://192.168.10.119:8081/api/create/capsule');
    final headers = {'Content-Type': 'application/json'};

    final Map<String, dynamic> requestBody = {
      'textData': text_Data,
      'capsuleLat': capselLat.toString(),
      'capsuleLon': capselLon.toString(),
      'userId': userId,
      'imageDataBase64': image_pref,
      // 他のデータも追加する
    };

    final String encodedBody = json.encode(requestBody);
    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        print('カプセル内容のPOSTリクエスト成功');
        print('サーバーレスポンスは：${response.body}です');
        print('あああ${encodedBody}');
        final List<int> bytes = response.bodyBytes;
        final Map<String, dynamic> capsuleData =
            jsonDecode(utf8.decode(bytes)); //
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
  }
}
