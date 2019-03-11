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
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        globals.authStatus = userId == null ? globals.AuthStatus.notSignedIn : globals.AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      globals.authStatus = globals.AuthStatus.signedIn;
    });
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
        if (globals.hasDojo) {
          return HomePage(
            auth: widget.auth,
          );
        } else {
          return JoinDojoPage(
            auth: widget.auth,
            db: Db(),
          );
        }
    }
  }
}