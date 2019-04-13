import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:kokushi_connect/create_class_page.dart';
import 'package:kokushi_connect/create_event_page.dart';
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
          builder: (context) => EventPage(auth: widget.auth, db: widget.db, date: date,),
        )
    );
  }

  void moveToCreateEventPage() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateClassPage(auth: widget.auth, db: widget.db),
        )
    );
  }
}


class EventPage extends StatefulWidget {
  EventPage({this.auth, this.db, this.date});

  final BaseAuth auth;
  final Database db;
  final DateTime date;

  State<StatefulWidget> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>{
  @override
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(months[widget.date.month] + " " + widget.date.day.toString() + ", " + widget.date.year.toString()),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),

      body: Container(
        child: Column(children: [
          new Expanded(child: ListView(children: getEventList(widget.date))),
          RaisedButton(
            child: Text('Create New Event', style: TextStyle(fontSize: 20)),
            onPressed: moveToCreateEventPage,

          ),
        ]),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
      ),
    );
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