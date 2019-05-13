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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.dojoClass.name),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),

      body: Container(child: Column(children: [
        new Expanded(child: ListView(children: [
          ListTile(title: Text(widget.dojoClass.description)),
          ListTile(title: Text("Taught by " + widget.dojoClass.userId)),
        ])),
        RaisedButton(
          child: Text('Members', style: TextStyle(fontSize: 20)),
          onPressed: moveToMembers,
        ),

        RaisedButton(
          child: Text('Dates', style: TextStyle(fontSize: 20)),
          onPressed: moveToDates,
        ),
      ])
      ),
    );
  }

  void moveToMembers() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClassMembersPage(auth: widget.auth, db: widget.db, dojoClass: widget.dojoClass,),
        )
    );
  }

  void moveToDates() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClassEventsPage(auth: widget.auth, db: widget.db, dojoClass: widget.dojoClass),
        )
    );
  }

}