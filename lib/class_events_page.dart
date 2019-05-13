import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/attendance_page.dart';
import 'package:kokushi_connect/calendar_page.dart';
import 'package:kokushi_connect/classes_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class ClassEventsPage extends StatefulWidget {
  ClassEventsPage({this.auth, this.db, this.dojoClass});

  final BaseAuth auth;
  final Database db;
  final Class dojoClass;

  State<StatefulWidget> createState() => _ClassEventsPageState();
}

class _ClassEventsPageState extends State<ClassEventsPage> {
  String dojoId = "";
  List<CalendarEvent> eventList = [];
  Map<String, Map<String, bool>> attendance = new Map();
  bool _loading = true;


  getEvents(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    List<ListTile> eventTiles = [];
    snapshot.data.documents.forEach((document) {
      Map<String, dynamic> eventInfo = document.data;
      //if (eventInfo['accountType'] != 'Coach'){
      CalendarEvent event = new CalendarEvent();
      event.id = document.documentID;
      event.classId = eventInfo['classId'];
      event.start = eventInfo['startDate']; //not editable
      event.end = eventInfo['endDate']; //not editable
      event.title = eventInfo['title']; //editable
      event.userId = eventInfo['userId']; //definite not editable
      event.description = eventInfo['description']; //editable
      //add email, uneditable, phone, also uneditable, up to you -AO
      //}
      if(eventInfo['attendance'] != null) {
        print("Event: " + event.id);
        attendance[event.id] = Map.from(eventInfo['attendance']);
      }
      eventList.add(event);
      eventTiles.add(new ListTile(
        title: Text(DateFormat("MMMM EEEE d y").format(event.start)),
        onTap: () {
          moveToEventPage(event, attendance[event.id]);
        },
      ));
    });

    return eventTiles;
  }

  void initState() {
    super.initState();
    getDojoId();
  }


  void getDojoId() async {
    dojoId = await widget.db.getUserDojo(await widget.auth.currentUser());
    print(dojoId);
    /*QuerySnapshot docs = await Firestore.instance.collection('dojos').document(dojoId).collection('members').getDocuments();
    docs.documents.forEach((document) async {

    });
    print("in getDojoId after for each: students: $students");*/
    setState(() {
      _loading = false;
    });

  }

  void moveToEventPage(CalendarEvent event, Map attendance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendancePage(auth: widget.auth, db: widget.db, event: event, dojoClass: widget.dojoClass, attendance: attendance),
      ),
    );
  }

  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text("Class"),
          context: context,
          auth: widget.auth,
          db: widget.db,
        ),

        body: Container(
          child: Column(children: [
            new Expanded(child: StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .where('classId', isEqualTo: widget.dojoClass.id,).where('dojoId', isEqualTo: dojoId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Text("Error!");
                else if (!snapshot.hasData) return Text("No Students");
                return ListView(children: getEvents(snapshot),);
              },
            )),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }
}