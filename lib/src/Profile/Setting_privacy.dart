import 'package:flutter/material.dart';

class Item3Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシー設定'),
      ),
      body:
          const Center(child: Text('鍵垢設定など', style: TextStyle(fontSize: 32.0))),
    );
  }
}
