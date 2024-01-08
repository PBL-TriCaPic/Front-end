import 'package:flutter/material.dart';

class MySearchAppBar extends StatefulWidget {
  @override
  _MySearchAppBarState createState() => _MySearchAppBarState();
}

class _MySearchAppBarState extends State<MySearchAppBar> {
  TextEditingController _textController = TextEditingController();
  bool _isSearching = false;
  //List<int> _searchIndexList = [];

  // 適切なバックエンドリクエスト関数を呼び出すメソッド
  Future<bool> _searchBackend(String query) async {
    // バックエンドに対するリクエストの実装
    // ここでは仮にfalseを返しています。実際にはバックエンドとの通信を行い、結果を返すロジックを追加してください。
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  // 検索結果に応じて適切な表示を更新するメソッド
  void _updateSearchResults(String query) async {
    setState(() {
      //_searchIndexList = [];
      _isSearching = true;
    });

    // 適切なバックエンドリクエスト関数を呼び出す
    bool isMatch = await _searchBackend(query);

    setState(() {
      _isSearching = false;
      if (isMatch) {
        // バックエンドから詳細情報を取得するロジックを実装
        // ここでは仮に詳細情報があるとして、結果を元にbodyを生成しています。
        // 実際にはバックエンドからの詳細情報を利用して適切なbodyを生成するロジックを追加してください。
        // 以下は仮のコードです。
        _generateBodyWithDetails();
      } else {
        // 一致するものがない場合、"not found"を表示
        _generateBodyNotFound();
      }
    });
  }

  // バックエンドから詳細情報を取得し、適切なbodyを生成するメソッド
  void _generateBodyWithDetails() {
    // 仮の詳細情報取得ロジック
    // ここでは詳細情報があると仮定して、それを元にbodyを生成しています。
    // 実際にはバックエンドからの詳細情報を利用して適切なbodyを生成するロジックを追加してください。
    String details = "詳細情報";
    _generateBody(details);
  }

  // "not found"を表示するメソッド
  void _generateBodyNotFound() {
    _generateBody("not found");
  }

  // bodyを生成するメソッド
  void _generateBody(String bodyContent) {
    // ここではbodyの生成ロジックを仮実装
    // 実際には詳細なUIやデータを表示するためのWidgetを追加してください。
    print("Generated Body: $bodyContent");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("Your App Title"),
        actions: _buildAppBarActions(),
      ),
      body: Center(
        // ここに生成されたbodyを表示するWidgetを追加
        child: Text("Body Content"),
      ),
    );
  }

  // 検索フィールドを生成するメソッド
  Widget _buildSearchField() {
    return TextField(
      controller: _textController,
      autofocus: true,
      onChanged: (String text) {
        // テキストが変更されるたびに検索結果を更新
        _updateSearchResults(text);
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
            // 検索ボックスをクリア
            _textController.clear();
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

  // AppBarのアクションを生成するメソッド
  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // 検索を開始
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ];
    }
  }
}
