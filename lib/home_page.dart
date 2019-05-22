import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/attendance_page.dart';
import 'package:kokushi_connect/calendar_page.dart';
import 'package:kokushi_connect/classes_page.dart';
import 'package:kokushi_connect/event_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;

  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dojoId;
  bool _loading = true;
  List<CalendarEvent> events = [];
  Map<String, Map<String, bool>> attendance = new Map();
  
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
  
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text('Welcome'),
          context: context,
          auth: widget.auth,
          db: widget.db,
        ),

        body: Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('events')
                .where('dojoId', isEqualTo: dojoId).where('startDate', isGreaterThanOrEqualTo: DateTime.now()).where('startDate', isLessThan: DateTime.now().add(new Duration(days: 14)))
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return Text("Error!");
              else if (!snapshot.hasData) return Text("No Students");
              return getRecentEvents(snapshot);
            },
          ),
        ),
      );
    }
  }

  ListView getRecentEvents(AsyncSnapshot<QuerySnapshot> snapshot) {
    TextStyle title = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    int day = DateTime.now().day - 1;
    DateFormat format = new DateFormat("EEEE, MMMM d, y");
    TextStyle date = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    List<Widget> eventTiles = [];
    eventTiles.add(new ListTile(
      title: Text("Upcoming Events:", style: title,),
    ));
    snapshot.data.documents.forEach((document) {
      Map<String, dynamic> eventInfo = document.data;
      DateTime currDate = eventInfo['startDate'];
      print("Day: " + currDate.day.toString());
      CalendarEvent event = new CalendarEvent();
      event.id = document.documentID;
      event.classId = eventInfo['classId'];
      event.start = eventInfo['startDate']; //not editable
      event.end = eventInfo['endDate']; //not editable
      event.title = eventInfo['title']; //editable
      event.userId = eventInfo['userId']; //definite not editable
      event.description = eventInfo['description'];
      if(eventInfo["attendance"] != null) {
        try {
          attendance[event.id] = Map.from(eventInfo['attendance']);
        }
        catch (e) {
          attendance[event.id] = new Map();
        }
      }
      events.add(event);
      if (currDate.day != day) {
        day = currDate.day;
        eventTiles.add(new ListTile(
          title: Text(format.format(currDate), style: date,),
        ));
      }
      eventTiles.add(Divider());
      eventTiles.add( new ListTile(
        title: Text(eventInfo['title']),
        onTap: () {
          moveToEvents(event);
        },
      ));

    });

    return ListView(
      children: eventTiles,
    );
  }

  void moveToEvents (CalendarEvent event) {
    Class dojoClass = null;
    if (event.classId != null) {
      dojoClass = new Class();
      dojoClass.id = event.classId;
    }
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              AttendancePage(auth: widget.auth, db: widget.db, event: event, attendance: attendance[event.id], dojoClass: dojoClass,),
        )
    );
  }

}
