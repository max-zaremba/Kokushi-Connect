import 'package:flutter/material.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
import 'dart:math';

import 'package:kokushi_connect/db_control.dart';

class Student {
  final String name;
  final String description;
  final DateTime dob;

  Student(this.name, this.description, this.dob);
}

List <Student> randStud() {
  var rand = new Random();

    return List.generate(
        20, (i) => Student(
        'Student $i',
        'A description of what needs to be done for student $i',
        new DateTime(1995 + rand.nextInt(15), 1 + rand.nextInt(11), 1 + rand.nextInt(30)),
      )
  );
}

class StudentListPage extends StatefulWidget {

  StudentListPage({this.auth, this.db, this.students});
  final BaseAuth auth;
  final Database db;
  final List<Student> students;

  @override
  State<StatefulWidget> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Student Info'),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),
      body: ListView.builder(
        itemCount: widget.students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.students[index].name),
            // When a user taps on the ListTile, navigate to ParentDetail.
            // passes student to new ParentDetail
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(auth: widget.auth, db: widget.db, student: widget.students[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class InfoPage extends StatefulWidget {
  final Student student;
  final BaseAuth auth;
  final Database db;

  InfoPage({this.auth, this.db, this.student});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  InfoPage get widget => super.widget;

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.student.name),
        context: context,
        auth: widget.auth,
        db: widget.db,
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
              children: <Widget>[

                //date of birth
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        child: Text('D.O.B: ' + widget.student.dob.month.toString() + '-' + widget.student.dob.day.toString() + '-' + widget.student.dob.year.toString())
                    )
                ),

                //rank
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          hintText: '...',
                          labelText: 'Rank'
                      ),
                    )
                ),


                //assistant instructor?
                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    child: CheckboxListTile(
                      title: Text('Assistant Instructor'),
                      value: _isChecked,
                      onChanged: (bool newValue) {
                        setState(() {
                          _isChecked = newValue;
                        });
                      },
                    )
                ),

                //note
                Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: TextField(
                        maxLines: 99,
                        decoration: InputDecoration(
                          hintText: "additional info...",
                          border: OutlineInputBorder(),
                        )
                    )
                )

              ]
          )
      ),
    );
  }
}
