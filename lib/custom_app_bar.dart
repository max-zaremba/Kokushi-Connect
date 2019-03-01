import 'package:flutter/material.dart';
import 'root_page.dart';
import 'auth.dart';
import 'globals.dart' as globals;

class CustomAppBar extends AppBar {
  CustomAppBar({Key key, Widget title, BuildContext context, Auth auth})
      : super(key: key, title: title, actions: <Widget>[
        FlatButton(
          child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
          onPressed: () async {
            try {
              await auth.signOut();
              globals.authStatus = globals.AuthStatus.signedIn;
            } catch (e) {

            }
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MaterialApp(
                      home: RootPage(auth: auth),
                    );
                  }
              ));
        }
  )]);

  void moveToRoot(BuildContext context) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return MaterialApp(
                home: RootPage(auth: Auth()),
              );
            }
        ));
  }
}