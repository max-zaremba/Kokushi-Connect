import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: _signOut,
          )
        ],
      ),
      body: Container(
        child: dock,
      ),
    );

  }
  Widget dock = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [Row (
      children: [
        Column(
          children: [
            Icon(Icons.calendar_today, size: 48,),
            Text("Calendar"),
          ],
        ),
        Column(
          children: [
            Icon(Icons.check_box, size: 48,),
            Text("Attendence")
          ],
        ),
        Column(
          children: [
            Icon(Icons.note, size: 48,),
            Text("Notes")
          ],
        ),
        Column(
          children: [
            Icon(Icons.message, size: 48,),
            Text("Messages")
          ],
        ),
        Column(
          children: [
            Icon(Icons.info, size: 48,),
            Text("Info")
          ],
        ),
        Column(
          children: [
            Icon(Icons.settings, size: 48,),
            Text("Settings"),
          ],
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    )]
  );
}