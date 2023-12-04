import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Code_Success extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('コード認証'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: TextField(
                controller: codeController, // テキストフィールドのコントローラーを指定
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                ],
                decoration: InputDecoration(
                  labelText: 'コード入力',
                ),
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () {
                  // テキストフィールドの値を取得
                  String code = codeController.text;
                  if (code.length == 4 && RegExp('[0-9]').hasMatch(code)) {
                    // 条件を満たす場合、画面遷移
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => Passwordforget2()),
                    // );
                  } else {
                    // 条件を満たさない場合、エラーを表示または処理を行う
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('エラー'),
                          content: Text('有効なコードを入力してください。'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('閉じる'),
                            ),
                          ],
                        );
                      },
                    );
                  }
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