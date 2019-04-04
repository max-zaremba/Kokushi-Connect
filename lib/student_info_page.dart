import 'package:flutter/material.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kokushi_connect/db_control.dart';

class Student {
  String id;
  String first_name;
  String last_name;
  String nickname;
  DateTime dob;
  String status;
  String rank;
  String description;

  Student();
}

// List <Student> randStud() {
//   var rand = new Random();

//     return List.generate(
//         20, (i) => Student(
//         'Student $i',
//         'A description of what needs to be done for student $i',
//         new DateTime(1995 + rand.nextInt(15), 1 + rand.nextInt(11), 1 + rand.nextInt(30)),
//       )
//   );
// }

class StudentListPage extends StatefulWidget {

  StudentListPage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  String dojoId = "";
  List<Student> students = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getDojoId();
  }

  void getDojoId() async {
    dojoId = await widget.db.getUserDojo(await widget.auth.currentUser());
    QuerySnapshot docs = await Firestore.instance.collection('dojos').document(dojoId).collection('members').getDocuments();
    docs.documents.forEach((document) async {
      String studentId = document.data.keys.first;
      Student stu = new Student();
      stu.id = studentId;
      stu.first_name = await widget.db.getFirstName(studentId);
      stu.last_name = await widget.db.getLastName(studentId);
      stu.nickname = await widget.db.getNickname(studentId);
      stu.dob = await widget.db.getDOB(studentId);
      stu.status = await widget.db.getAccountType(studentId);
      stu.rank = await widget.db.getRank(studentId);
      stu.description = await widget.db.getDescription(studentId);
      students.add(stu);
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      /*return Scaffold(
          appBar: CustomAppBar(
            title: Text('Student Info'),
            context: context,
            auth: widget.auth,
            db: widget.db,
          ),
          body: StreamBuilder(
            stream: Firestore.instance.collection('dojos')
                .document(dojoId)
                .collection('members')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text("Error!");
              else if (!snapshot.hasData) return Text("No Students");
              return ListView(children: getStudents(),);
            },
          ) */
        return Scaffold(
          appBar: CustomAppBar(
            title: Text('Student Info'),
            context: context,
            auth: widget.auth,
            db: widget.db,
          ),
          body: ListView(children: getStudents(),)
        );
    }
  }

  getStudents() {
    print("Get students called");
    List<ListTile> stdnts = [];
    for(Student stu in students){
      stdnts.add(ListTile(
            title: Text(stu.first_name + " " + stu.last_name),
            // When a user taps on the ListTile, navigate to ParentDetail.
            // passes student to new ParentDetail
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(auth: widget.auth, db: widget.db, student: stu),
                ),
              );
            },
          ));
    }
    return stdnts;
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
        title: Text(widget.student.first_name + " " + widget.student.last_name),
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
                          hintText: 'Enter rank',
                          labelText: widget.student.rank
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
