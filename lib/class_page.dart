import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/calendar_page.dart';
import 'package:kokushi_connect/class_events_page.dart';
import 'package:kokushi_connect/class_members_page.dart';
import 'package:kokushi_connect/classes_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class ClassPage extends StatefulWidget {
  ClassPage({this.auth, this.db, this.dojoClass});

  final BaseAuth auth;
  final Database db;
  final Class dojoClass;

  State<StatefulWidget> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  DateFormat format = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  int oldOrNew = -1;
  String buttonText = "See Old Events";
  String titleText = "Future Events";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.dojoClass.name),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),

      body: Container(child: Column(children: [
        ListTile(title: Text(widget.dojoClass.description)),
        ListTile(title: Text("Taught by " + widget.dojoClass.userId)),
        ListTile(title: Text(titleText, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
        new Expanded (child: ClassEventsPage(auth: widget.auth, db: widget.db, dojoClass: widget.dojoClass, oldOrNew: oldOrNew,)),
        RaisedButton(
          child: Text(buttonText, style: TextStyle(fontSize: 20)),
          onPressed: changeEvents,
        ),
      ])
      ),
    );
  }


  void moveToDates() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClassEventsPage(auth: widget.auth, db: widget.db, dojoClass: widget.dojoClass),
        )
    );
  }

  void changeEvents() {
    setState(() {
      oldOrNew *= -1;
      if (oldOrNew == -1) {
        buttonText = "See Old Events";
        titleText = "Future Events";
      }

      else {
        buttonText = "See Future Events";
        titleText = "Old Events";
      }
    });
  }

}