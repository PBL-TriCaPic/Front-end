// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Item3Screen extends StatelessWidget {
  const Item3Screen({super.key});

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
