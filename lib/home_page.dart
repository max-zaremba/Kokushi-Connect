import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Welcome'),
        context: context,
        auth: auth,
        db: db,
      ),
      body: Container(
        child: Center(
          child: Text('Welcome', style: TextStyle(fontSize: 32.0))
        ),
      ),
    );
  }
}