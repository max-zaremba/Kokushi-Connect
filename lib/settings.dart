import 'package:flutter/material.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
import 'auth.dart';
import 'root_page.dart';
import 'db_control.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;

  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("Settings"),
        context: context,
        auth: widget.auth,
        db: widget.db
      ),
    );
  }
}