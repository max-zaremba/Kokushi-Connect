import 'package:flutter/material.dart';
import 'dart:math';

class Student {
  final String name;
  final String description;
  final DateTime dob;

  Student(this.name, this.description, this.dob);
}

void main() {
  var rand = new Random();

  runApp(MaterialApp(
    title: 'Student Info',
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

class StudentListPage extends StatelessWidget {
  final List<Student> students;

  StudentListPage({Key key, @required this.students}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Info'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student.name),
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
