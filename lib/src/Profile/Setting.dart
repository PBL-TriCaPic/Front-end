// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'Setting_email_password.dart';
import 'Setting_default.dart';
import 'Setting_logout.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            child: SizedBox(
              height: 100,
              child: Text(
                "設定",
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          ListTile(
            title: const Text("メアド・パスワード"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Item1Screen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("起動時デフォルト"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Item2Screen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("ログアウト"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Item3Screen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
