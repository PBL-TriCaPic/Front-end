import 'package:flutter/material.dart';
import 'Setting_email_password.dart';
import 'Setting_default.dart';
import 'Setting_privacy.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              height: 100,
              child: const Text(
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
                  builder: (context) => Item1Screen(),
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
                  builder: (context) => Item2Screen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("プライバシー"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Item3Screen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
