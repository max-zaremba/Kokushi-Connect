import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:kokushi_connect/attendance_page.dart';
import 'package:kokushi_connect/create_class_page.dart';
import 'package:kokushi_connect/create_event_page.dart';
import 'package:kokushi_connect/event_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;

  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override

  DateTime _currentDate = DateTime.now();

  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Calendar'),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),

      body: Container(
        child: Column(children: [
          CalendarCarousel(
            height: 410,
            onDayPressed: (DateTime date, List<Event> events) {
              this.setState(() => _currentDate = date);
              events.forEach((event) => print(event.title));
              moveToEvents(date);
            },
            selectedDateTime: _currentDate,
          ),

          RaisedButton(
            child: Text('Create New Event', style: TextStyle(fontSize: 20)),
            onPressed: moveToCreateEventPage,
          ),
      ]),),
    );
  }

  void moveToEvents(DateTime date) {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventsPage(auth: widget.auth, db: widget.db, date: date,),
        )
    );
  }

  void moveToCreateEventPage() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateEventPage(auth: widget.auth, db: widget.db),
        )
    );
  }
}


class EventsPage extends StatefulWidget {
  EventsPage({this.auth, this.db, this.date});

  final BaseAuth auth;
  final Database db;
  final DateTime date;

  State<StatefulWidget> createState() => _EventsPageState();
}

class CalendarEvent {
  String id;
  String title;
  String description;
  String classId;
  DateTime start;
  DateTime end;
  String userId;

  CalendarEvent();
}

class _EventsPageState extends State<EventsPage>{
  @override

  String dojoId = "";
  List<CalendarEvent> eventList = [];
  bool _loading = true;
  
  List<String> months = [
    "Nulltober",
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  bool checkDay (DateTime date, DateTime start, DateTime end) {
    return (date.day == start.day && date.month == start.month && date.year == start.year) ||
        (date.day == end.day && date.month == end.month && date.year == end.year);
  }

  getStudents(AsyncSnapshot<QuerySnapshot> snapshot) {
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
      eventList.add(event);
      if (checkDay(widget.date, event.start, event.end)) {
        eventTiles.add(new ListTile(
          title: Text(event.title),
          onTap: () {
            moveToEventPage(event);
          },
        ));
      }
    });

    return eventTiles;
  }

  void moveToEventPage(CalendarEvent event) {
    if (event.classId == null) {
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                EventPage(auth: widget.auth, db: widget.db, event: event,),
          )
      );
    }
    else {
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                EventPage(auth: widget.auth, db: widget.db, event: event,),
          )
      );
    }
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

  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text(
              months[widget.date.month] + " " + widget.date.day.toString() +
                  ", " + widget.date.year.toString()),
          context: context,
          auth: widget.auth,
          db: widget.db,
        ),

        body: Container(
          child: Column(children: [
            new Expanded(child: StreamBuilder(
              stream: Firestore.instance
                  .collection('events')
                  .where('dojoId', isEqualTo: dojoId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Text("Error!");
                else if (!snapshot.hasData) return Text("No Students");
                return ListView(children: getStudents(snapshot),);
              },
            )),
            RaisedButton(
              child: Text('Create New Event', style: TextStyle(fontSize: 20)),
              onPressed: moveToCreateEventPage,

            ),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }

  void moveToCreateEventPage() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateEventPage(auth: widget.auth, db: widget.db, date: widget.date,),
        )
    );
  }

  List<Widget> getEventList(DateTime date) {
    List<ListTile> list = new List(20);
    for (int i = 0; i < list.length; i++) {
      list[i] = new ListTile(title: Text("We will be doing Judo, Come join us"));
    }
    return list;
  }

}