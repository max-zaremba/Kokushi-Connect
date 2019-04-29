import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/calendar_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class EventPage extends StatefulWidget {
  EventPage({this.auth, this.db, this.event});

  final BaseAuth auth;
  final Database db;
  final CalendarEvent event;

  State<StatefulWidget> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DateFormat format = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.event.title),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),

      body: Container(child:
        Column(children: [
          Text(format.format(widget.event.start) + " to " + format.format(widget.event.end) + "\n"),
          Text(widget.event.description),
          Text("Created by " + widget.event.userId)
        ])
      ),
    );
  }
}