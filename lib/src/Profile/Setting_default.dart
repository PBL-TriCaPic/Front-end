import 'package:flutter/material.dart';

class Item2Screen extends StatelessWidget {
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
