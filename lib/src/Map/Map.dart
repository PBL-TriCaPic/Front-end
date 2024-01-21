// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously, avoid_unnecessary_containers, void_checks, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_application_develop/src/Map/Follow_map.dart';
import 'package:flutter_application_develop/src/Map/My_map.dart';

import '../theme_setting/Color_Scheme.dart';

final ThemeData lightTheme =
    ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

class MapScreen extends StatelessWidget {
  // ignore: use_super_parameters
  const MapScreen({Key? key}) : super(key: key);

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
                  icon: Icon(Icons.map),
                  text: '私の地図',
                ),
                Tab(icon: Icon(Icons.map_outlined), text: 'フレンドの地図'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              MyHomeScreen(
                title: '',
              ),
              FollowHomeScreen(
                title: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
