import 'package:flutter/material.dart';
import 'Code_Success.dart';

class Passwordforget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('パスワード再設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直方向に中央寄せ
          children: [
            Align(
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'e-mail',
                ),
              ),
            ),
            SizedBox(height: 50.0), // 適切な間隔を設定
            Container(
              width: MediaQuery.of(context).size.width * 0.4, // 画面幅の40%に設定
              child: ElevatedButton(
                onPressed: () {
                  // 以下は「入力完了」のボタンを押した時に呼ばれるコードを書く
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Code_Success()),
                  );
                },
                child: Text('入力完了'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
