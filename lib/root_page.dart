import 'package:flutter/material.dart';
import 'package:kokushi_connect/base_page.dart';
import 'login_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'globals.dart' as globals;
import 'join_dojo_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  SharedPreferences prefs;
  bool _hasDojo = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      _loading = true;
    });

    String userId = await widget.auth.currentUser();
    setState(() {
      globals.authStatus = userId == null ? globals.AuthStatus.notSignedIn : globals.AuthStatus.signedIn;
    });
    await doesHaveDojo();
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
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Container(
            child: AutoSizeText(
              "Kokushi Connect",
              style: TextStyle(color: Colors.white, fontFamily: 'Wunderbach', fontWeight: FontWeight.bold, fontSize: 100),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
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
            return BasePage(
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

