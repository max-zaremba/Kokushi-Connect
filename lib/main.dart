import 'package:flutter/material.dart';
import 'auth.dart';
import 'root_page.dart';
import 'db_control.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootPage(auth: Auth(), db: Db()),
    );
  }
}