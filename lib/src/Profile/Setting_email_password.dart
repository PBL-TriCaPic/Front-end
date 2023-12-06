// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Item1Screen extends StatelessWidget {
  const Item1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メアド・パスワード設定'),
      ),
      body: const Center(
          child: Text('メアド・パスワード設定画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}
