// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Item2Screen extends StatelessWidget {
  const Item2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('起動時デフォルト設定'),
      ),
      body: const Center(
          child: Text('起動時デフォルト設定\n デフォルトをMapに設定\n or\n デフォルトをカプセル作成に設定',
              style: TextStyle(fontSize: 32.0))),
    );
  }
}
