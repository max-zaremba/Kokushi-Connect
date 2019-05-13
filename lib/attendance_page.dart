import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/calendar_page.dart';
import 'package:kokushi_connect/classes_page.dart';
import 'package:kokushi_connect/student_info_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({this.auth, this.db, this.event, this.dojoClass, this.attendance});

  final BaseAuth auth;
  final Database db;
  final CalendarEvent event;
  final Class dojoClass;
  final Map<String, bool> attendance;

  State<StatefulWidget> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String dojoId = "";
  List<Student> studentList = [];
  bool _loading = true;
  Map<String, bool>_isChecked;


  void updateAttendance () async {
    DocumentReference doc = Firestore.instance.collection('events').document(widget.event.id);
    Map<String, bool> newAttendance = _isChecked;
    await doc.updateData({'attendance' : newAttendance});
    Navigator.pop(context);
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
          title: Text("Class"),
          context: context,
          auth: widget.auth,
          db: widget.db,
        ),

        body: Container(
          child: Column(children: [
            new Expanded(child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
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
              child: Text('Update Attendance', style: TextStyle(fontSize: 20)),
              onPressed: updateAttendance,
            ),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }
  getStudent(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("hello");
    snapshot.data.documents.forEach((document)  {
      Map<String, dynamic> studentInfo = document.data;
      print("Hello " + document.documentID);
    });
    return new ListTile(title: Text("Hello"),);
  }
  getStudents(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    List<CheckboxListTile> studentTiles = [];
    if (_isChecked == null) {
      if(widget.attendance == null) {
        _isChecked = new Map();
      }
      else {
        _isChecked = widget.attendance;
      }
    }
    snapshot.data.documents.forEach((document) {
      Map<String, dynamic> studentInfo = document.data;
      //if (eventInfo['accountType'] != 'Coach'){
      if (studentInfo['accountType'] != 'Coach' && widget.dojoClass.members[document.documentID] != null){
        Student stu = new Student();
        stu.id = document.documentID;
        stu.first_name = studentInfo['firstName'];//not editable
        stu.last_name = studentInfo['lastName'];//not editable
        stu.nickname = studentInfo['nickname'];//editable
        stu.dob = studentInfo['dob'];//definite not editable
        stu.status = studentInfo['accountType'];//editable
        stu.rank = studentInfo['rank'];//editable
        print(stu.id);

        if (_isChecked[stu.id] == null) {
          print("Stud" + stu.id);
          _isChecked[stu.id] = false;
        }
        //add email, uneditable, phone, also uneditable, up to you -AO

        studentList.add(stu);
        studentTiles.add(CheckboxListTile(
          title: Text(stu.first_name + " " + stu.last_name),
          value: _isChecked[stu.id],
          onChanged: (bool newValue) {
            setState(() {
              _isChecked[stu.id] = newValue;
            });
          },
        ),);
      }
    });

    return studentTiles;
  }

}