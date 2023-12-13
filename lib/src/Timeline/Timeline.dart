// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../theme_setting/Color_Scheme.dart';
import 'Friend_Timeline.dart';
import 'My_timeline.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              'assets/TriCaPic_logo.png',
              height: 200,
              width: 200,
            ),
            elevation: 3,
            shadowColor: Colors.black,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                  text: '私のカプセル',
                ),
                Tab(icon: Icon(Icons.people_alt_rounded), text: 'フレンドのカプセル'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyTab(),
              FriendTab(),
            ],
          ),
        ),
      ),
    );
  }
}
