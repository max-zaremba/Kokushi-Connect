import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'home_page.dart';
import 'globals.dart' as globals;
import 'join_dojo_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool hasDojo = false;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        globals.authStatus = userId == null ? globals.AuthStatus.notSignedIn : globals.AuthStatus.signedIn;
      });
      doesHaveDojo();
    });
  }

  void doesHaveDojo() async {
    String userId = await widget.auth.currentUser();
    if (userId != null && await widget.db.getUserDojo(userId) != null) {
      hasDojo = true;
    } else {
      hasDojo = false;
    }
  }

  void _signedIn() {
    setState(() {
      globals.authStatus = globals.AuthStatus.signedIn;
    });
    doesHaveDojo();
  }

  @override
  Widget build(BuildContext context) {
    switch (globals.authStatus) {
      case globals.AuthStatus.notSignedIn:
        return LoginPage(
          auth: widget.auth,
          onSignedIn: _signedIn,
        );
      case globals.AuthStatus.signedIn:
        if (hasDojo) {
          return HomePage(
            auth: widget.auth,
            db: widget.db,
          );
        } else {
          return JoinDojoPage(
            auth: widget.auth,
            db: widget.db,
          );
        }
    }
  }
}