import 'package:flutter/material.dart';
import 'package:kokushi_connect/db_control.dart';
import 'package:kokushi_connect/home_page.dart';
import 'package:kokushi_connect/student_info_page.dart';
import 'auth.dart';


class BasePage extends StatefulWidget {
  BasePage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;
  State<StatefulWidget> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override

  List <Widget> pages() {
    return [
      HomePage(auth: widget.auth, db: widget.db),
      null,
      null,
      StudentListPage(auth: widget.auth, db: widget.db,),
      null,
      null,
    ];
  }
  int pageNum = 0;

  Widget page() {
    return pages()[pageNum];
  }

  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          //child: updatesAndEvents(),
          child: Column(children: <Widget>[new Expanded(child: page()), dock()], mainAxisAlignment: MainAxisAlignment.start,),
        ),
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
                  onPressed:  () {
                    setState(() {
                      pageNum = 0;
                    });
                  },
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
                  onPressed: () {
                    setState(() {
                      pageNum = 1;
                    });
                  },
                  alignment: Alignment.center,
                  iconSize: 36,
              ),
              Text("Calendar"),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.check_box,),
                onPressed:  () {
                  setState(() {
                    pageNum = 2;
                  });
                },
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
                  onPressed:  () {
                    setState(() {
                      pageNum = 3;
                    });
                  },
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
                  onPressed:  () {
                    setState(() {
                      pageNum = 4;
                    });
                  },
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
                  onPressed:  () {
                    setState(() {
                      pageNum = 5;
                    });
                  },
                  alignment: Alignment.center,
                  iconSize: 36
              ),
              Text("Settings"),
            ],
          ),
        ],
      );}
  }



