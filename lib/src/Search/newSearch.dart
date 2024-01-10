// ignore_for_file: file_names

import 'package:flutter/material.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme_setting/Color_Scheme.dart';
import 'package:lottie/lottie.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// テキスト入力フィールドのコントローラ
TextEditingController _textController = TextEditingController();
// 検索状態を管理するプロバイダー

final List<String> wordList = [
  "Hello",
  "Good morning",
  "Good afternoon",
  "Good evening",
  "Good night",
  "Good bye",
  "Bye",
  "See you later",
  "taku",
  "fun",
  "Hakodate",
  "kanagawa",
  "Housei",
  "Tokyo",
  "Kyoto",
  "PBL",
  "TriCaPic",
  "darui",
  "はこだて未来大学",
  "神奈川工科大学",
  "法政大学",
  "京都橘大学",
  "ミライケータイプロジェクト",
];
// 検索結果のインデックスリストを管理するプロバイダー

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: SearchScreenpage(),
    );
  }
}

class SearchScreenpage extends StatefulWidget {
  @override
  State<SearchScreenpage> createState() => MyHomePageState();
}

class MyHomePageState extends State<SearchScreenpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.black,
        title: _searchTextField(_textController),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _defaultListView(),
      ),
    );
  }

  Widget _searchTextField(TextEditingController textController) {
    return TextField(
      controller: textController,
      autofocus: false,
      onChanged: (String text) {
        // 入力テキストに一致する単語のインデックスを検索し、リストに追加
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            textController.clear();
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            width: 0.8,
            style: BorderStyle.solid,
          ),
        ),
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade600),
        hintText: "検索",
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _defaultListView() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/Search_Friend.json',
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  '友達を探そう！！',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
