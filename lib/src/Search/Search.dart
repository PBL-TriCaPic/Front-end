import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

// テキスト入力フィールドのコントローラ
TextEditingController _textController = TextEditingController();
// 検索状態を管理するプロバイダー
final onSearchProvider = StateProvider((ref) => false); // デフォルトで検索中フラグをfalseに設定
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
final StateProvider<List<int>> searchIndexListProvider =
    StateProvider((ref) => []);

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: lightTheme,
        home: const _SearchScreen(),
      ),
    );
  }
}

class _SearchScreen extends ConsumerWidget {
  const _SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onSearch = ref.watch(onSearchProvider);

    return Scaffold(
        appBar: AppBar(
          elevation: 3,
          shadowColor: Colors.black,
          title: _searchTextField(ref, _textController),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: onSearch ? _searchListView(ref) : _defaultListView(),
        ));
  }

  Widget _searchTextField(WidgetRef ref, TextEditingController textController) {
    //検索テキストフィールドを描画し、テストの変更に応じて検索結果を更新します
    final searchIndexListNotifier = ref.watch(searchIndexListProvider.notifier);
    final onSearchNotifier =
        ref.read(onSearchProvider.notifier); // onSearchNotifier を読み込む
    return TextField(
      controller: textController,
      autofocus: false,
      onChanged: (String text) {
        onSearchNotifier.state = true; // 検索中フラグをtrueに設定
        searchIndexListNotifier.state = [];
        // 入力テキストに一致する単語のインデックスを検索し、リストに追加
        for (int i = 0; i < wordList.length; i++) {
          if (wordList[i].contains(text)) {
            searchIndexListNotifier.state.add(i);
          }
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.grey.shade600,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            textController.clear();
            searchIndexListNotifier.state = [];
            onSearchNotifier.state = false; //入力を全て消したとき検索中フラグをfalseに設定
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(
            //color: Colors.blue, // 枠線の色
            width: 0.8, // 枠線の太さ
            style: BorderStyle.solid, // 枠線のスタイル（実線）
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

  Widget _searchListView(WidgetRef ref) {
    //検索結果を表示するリスト
    final searchIndexListNotifier = ref.watch(searchIndexListProvider.notifier);
    final searchIndexList = ref.watch(searchIndexListProvider);
    return ListView.builder(
        itemCount: searchIndexList.length,
        itemBuilder: (context, int index) {
          index = searchIndexListNotifier.state[index];
          return Card(
            child: ListTile(
              // onTap: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               SearchDetailPage(title: wordList[index])));
              // },//ここにListViewのTileを押したときの画面遷移をかく。他の人のプロフィール表示
              title: Text(wordList[index]),
              tileColor: Color.fromARGB(255, 255, 255, 255),
            ),
          );
        });
  }

  Widget _defaultListView() {
    //検索が行われていない場合に表示されるデフォルトのリスト
    return ListView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               SearchDetailPage(title: wordList[index])));
            // },//ここにListViewのTileを押したときの画面遷移をかく。他の人のプロフィール表示
            title: Text(wordList[index]),
            tileColor: Color.fromARGB(255, 255, 255, 255),
          ),
        );
      },
    );
  }
}
