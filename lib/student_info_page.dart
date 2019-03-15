import 'package:flutter/material.dart';
import 'dart:math';

class Student {
  final String name;
  final String description;
  final DateTime dob;

  Student(this.name, this.description, this.dob);
}

class StudentInfo extends StatelessWidget {
  var rand = new Random();

  Widget build(BuildContext context) {
    return (MaterialApp(
      title: 'Student Info',
      theme: ThemeData(
          hintColor: Color.fromRGBO(180, 180, 180, 1.0)
      ),
      home: StudentListPage(
        //generating dummy data
        students: List.generate(
          20, (i) => Student(
          'Student $i',
          'A description of what needs to be done for student $i',
          new DateTime(1995 + rand.nextInt(15), 1 + rand.nextInt(11), 1 + rand.nextInt(30)),
        ),
        ),
      ),
    ));
  }
}

class StudentListPage extends StatelessWidget {
  final List<Student> students;

  StudentListPage({Key key, @required this.students}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Student Info'),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0)
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students[index].name),
            // When a user taps on the ListTile, navigate to ParentDetail.
            // passes student to new ParentDetail
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(student: students[index]),
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

  InfoPage({Key key, @required this.student}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  InfoPage get widget => super.widget;

  bool _isChecked = false;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.student.dob.month.toString() + '-' + widget.student.dob.day.toString() + '-' + widget.student.dob.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.1,
          title: Text(widget.student.name),
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          centerTitle: true
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
              children: <Widget>[

                //date of birth
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          enabled: false,
                          labelText: 'D.O.B.'
                      ),
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
                    padding: EdgeInsets.only(bottom: 5.0),
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
