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
  String name = "";


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
    await getName();
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
    bool showDescription = (widget.dojoClass == null);
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      String title = "";
      if (widget.dojoClass == null) {
        title = widget.event.title;
      }
      else {
        title = widget.event.title + ": " + DateFormat("MMMM d, y").format(widget.event.start);
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),

        body: Container(
          child: Column(children: [
            Visibility (child: ListTile(title: Text(widget.event.description)), visible: showDescription,),
            Visibility (child: Divider(), visible: showDescription,),
            Visibility (child: ListTile(title: Text("Created by " + name)), visible: showDescription,),
            Visibility (child: Divider(), visible: showDescription,),
            Visibility (child: ListTile(title: Text("Attendence", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
            ),),), visible: widget.attendance != null,),
            Visibility (child: Divider(), visible: widget.attendance != null,),
            Visibility (child:
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
            )), visible: widget.attendance != null,),
            Visibility (child:
              RaisedButton(
                child: Text('Update Attendance', style: TextStyle(fontSize: 20)),
                onPressed: updateAttendance,
              ),
              visible: widget.attendance != null,),

          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }

  void getName () async{
    String first = await widget.db.getFirstName(widget.event.userId);
    String last = await widget.db.getLastName(widget.event.userId);
    name = first + " " + last;
  }

  getStudents(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    List<Widget> studentTiles = [];
    if (_isChecked == null) {
      _isChecked = widget.attendance;
    }
    snapshot.data.documents.forEach((document) {
      Map<String, dynamic> studentInfo = document.data;
      //if (eventInfo['accountType'] != 'Coach'){
      if (studentInfo['accountType'] != 'Coach'){
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
        if(studentTiles.isNotEmpty) {
          studentTiles.add(Divider());
        }
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