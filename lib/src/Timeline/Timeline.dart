import 'package:flutter/material.dart';
import '../theme_setting/Color_Scheme.dart';
import '../Capsule_open/CapContents.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: _timeline(),
    );
  }
}

class _timeline extends StatefulWidget {
  @override
  State<_timeline> createState() => _timelinePageState();
}

class _timelinePageState extends State<_timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/TriCaPic_logo.png',
          height: 200,
          width: 200,
        ),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('タイムライン画面', style: TextStyle(fontSize: 32.0)),
            SizedBox(height: 20.0), // Add some spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    //カプセル作成画面に遷移
                    return CapContentsScreen();
                  }),
                );
              },
              child: Text('ボタン'),
            ),
          ],
        ),
      ),
    );
  }
}
