import 'package:flutter/material.dart';
import '../theme_setting/Color_Scheme.dart';

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
        title: const Text('タイムライン画面'),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: const Center(
          child: Text('タイムライン画面', style: TextStyle(fontSize: 32.0))),
    );
  }
}
