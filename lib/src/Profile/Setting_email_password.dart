import 'package:flutter/material.dart';

class Item1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メアド・パスワード設定'),
      ),
      body: const Center(
          child: Text('メアド・パスワード設定画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}
