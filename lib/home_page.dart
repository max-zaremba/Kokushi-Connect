import 'package:flutter/material.dart';
import 'auth.dart';
import 'custom_app_bar.dart';
import 'root_page.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth});
  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Welcome'),
        context: context,
        auth: auth,
      ),
      body: Container(
        child: Center(
          child: Text('Welcome', style: TextStyle(fontSize: 32.0))
        ),
      ),
    );
  }
}