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