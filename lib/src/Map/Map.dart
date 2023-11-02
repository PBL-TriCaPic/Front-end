import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      //theme: themeProvider.selectedTheme,
      // theme: lightTheme,
      // darkTheme: darkTheme,
      title: 'Flutter Demo',
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
            body: Column(
              children: [
                const Center(
                    child: Text('Map画面', style: TextStyle(fontSize: 32.0))),
                // Switch(
                //   value: _light,
                //   onChanged: (bool value) {
                //     _toggleTheme();
                //   },
                // ),
              ],
            )));
  }
}
