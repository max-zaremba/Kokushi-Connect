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
  bool _hasDojo = false;
  bool _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    widget.auth.currentUser().then((userId) {
      setState(() {
        globals.authStatus = userId == null ? globals.AuthStatus.notSignedIn : globals.AuthStatus.signedIn;
      });
    });
    doesHaveDojo();
  }

  Future<void> doesHaveDojo() async {
    String userId = await widget.auth.currentUser();
    if (userId != null) {
      String dojoId = await widget.db.getUserDojo(userId);
      if (dojoId != null) {
        setState(() {
          _hasDojo = true;
        });
      } else {
        setState(() {
          _hasDojo = false;
        });
      }
    }
    setState(() {
      _loading = false;
    });
  }

  void _signedIn() async {
    await doesHaveDojo();
    setState(() {
      globals.authStatus = globals.AuthStatus.signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Container(
          color: Colors.blue,
          child: Text("KOKUSHI CONNECT"),
        ),
      );
    } else {
      switch (globals.authStatus) {
        case globals.AuthStatus.notSignedIn:
          return LoginPage(
            auth: widget.auth,
            db: widget.db,
            onSignedIn: _signedIn,
          );
        case globals.AuthStatus.signedIn:
          if (_hasDojo) {
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
}