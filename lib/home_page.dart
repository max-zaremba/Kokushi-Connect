import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: _signOut,
          )
        ],
      ),
      body: Container(
        //child: updatesAndEvents(),
        child: Column(children: <Widget>[new Expanded(child: updatesAndEvents()), dock()], mainAxisAlignment: MainAxisAlignment.start,),
      ),
    );

  }

  ListView updatesAndEvents() {
    TextStyle title = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    TextStyle date = TextStyle(fontSize: 20,);
    List<ListTile> updates = new List(11);
    updates[0] = new ListTile(
      title: Text("Updates:", style: title,),
    );
    for (int i = 1; i < updates.length; i++) {
      updates[i] = new ListTile(
        title: Text("Update " + i.toString()),
        subtitle: Text("Posted 2/2/22 2:22:22 by Mr. Zaremba"),
      );
    }
    List<ListTile> events = new List(12);
    events[0] = new ListTile(
      title: Text("Upcoming Events:", style: title,),
    );
    events[1] = new ListTile(
      title: Text("June 7, 2019", style: date,),
    );
    for (int i = 2; i < events.length; i++) {
      events[i] = new ListTile(
        title: Text("We will be doing Judo. Come Join Us."),
        subtitle: Text(i.toString() + ":00 PM"),
      );
    }

    return ListView(
      children: new List.from(updates)..addAll(events),
    );
  }

  Widget dock() {
    return Row (
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.home),
                onPressed: null,
                alignment: Alignment.center,
                iconSize: 36
            ),
            Text("Home")
          ],
        ),
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: null,
                alignment: Alignment.center,
                iconSize: 36
            ),
            Text("Calendar"),
          ],
        ),
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.check_box,),
                onPressed: null,
                alignment: Alignment.center,
                iconSize: 36,
            ),
            Text("Attendence")
          ],
        ),
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.note),
                onPressed: null,
                alignment: Alignment.center,
                iconSize: 36
            ),
            Text("Notes")
          ],
        ),
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.message),
                onPressed: null,
                alignment: Alignment.center,
                iconSize: 36
            ),
            Text("Messages")
          ],
        ),
        Column(
          children: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: null,
                alignment: Alignment.center,
                iconSize: 36
            ),
            Text("Settings"),
          ],
        ),
      ],
    );}}
