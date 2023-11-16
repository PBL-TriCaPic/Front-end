import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Profile/Profile.dart';
import 'Map/Map.dart';
import 'Search/Search.dart';
import 'Timeline/Timeline.dart';

final baseTabViewProvider = StateProvider<ViewType>((ref) => ViewType.map);

enum ViewType { map, timeline, search, profile }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends ConsumerWidget {
  MyStatefulWidget({Key? key}) : super(key: key);

  //@override
  //State<MyStatefulWidget> createState() => _MyStatefulWidgetState();

  final widgets = [
    const MapScreen(),
    const TimelineScreen(),
    const SearchScreen(),
    const AccountScreen(),
  ];

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   static const _screens = [
//     MapScreen(),
//     TimelineScreen(),
//     SearchScreen(),
//     AccountScreen()
//   ];

//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ThemeData selectedTheme = Provider.of<ThemeProvider>(context).selectedTheme;
    //int currentIndex = 0;
    final view = ref.watch(baseTabViewProvider.state);
    return Scaffold(
        body: widgets[view.state.index],
        bottomNavigationBar: Theme(
            data: ThemeData(splashFactory: NoSplash.splashFactory),
            child: BottomNavigationBar(
              //backgroundColor: selectedTheme.primaryColor,
              currentIndex: view.state.index,
              onTap: (int index) =>
                  view.update((state) => ViewType.values[index]),
              unselectedItemColor: Colors.grey, //Colors.grey,
              selectedItemColor:
                  Color.fromARGB(255, 0, 0, 0), //Color.fromARGB(255, 0, 0, 0),
              iconSize: 28,
              selectedIconTheme: const IconThemeData(size: 28),
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.map_outlined,
                    ),
                    label: '',
                    activeIcon: Icon(Icons.map)),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/Post.svg',
                      width: 23,
                      height: 23,
                      color: Colors.grey,
                    ),
                    label: '',
                    activeIcon: SvgPicture.asset(
                      'assets/PostActive.svg',
                      width: 24,
                      height: 24,
                      color: Color.fromARGB(255, 0, 0, 0),
                    )),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.search_sharp),
                    label: '',
                    activeIcon: Icon(Icons.search_sharp)),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined),
                    label: '',
                    activeIcon: Icon(Icons.account_circle_rounded)),
              ],
              type: BottomNavigationBarType.fixed,
            )));
  }
}
