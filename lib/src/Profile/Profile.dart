import 'package:flutter/material.dart';
import 'Setting_email_password.dart';
import 'Setting_default.dart';
import 'Setting_privacy.dart';
import '../theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List listTiles = <Widget>[
    const ListTile(title: Text('item1')),
    const ListTile(title: Text('item2')),
    const ListTile(title: Text('item3')),
    const ListTile(title: Text('item4')),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData selectedTheme = lightTheme;
    return MaterialApp(
        theme: selectedTheme,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('マイページ'),
              elevation: 3,
              shadowColor: Colors.black,
            ),
            endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    child: Container(
                      height: 100, // 高さを指定
                      child: const Text(
                        "設定",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text("メアド・パスワード"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Item1Screen(), // 遷移先の画面を指定
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("起動時デフォルト"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Item2Screen(), // 遷移先の画面を指定
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text("プライバシー"),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Item3Screen(), // 遷移先の画面を指定
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                const Center(
                    child: Text('プロフィール画面', style: TextStyle(fontSize: 32.0))),
              ],
            )));
  }
}
