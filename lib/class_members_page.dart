/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/calendar_page.dart';
import 'package:kokushi_connect/classes_page.dart';
import 'package:kokushi_connect/student_info_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class ClassMembersPage extends StatefulWidget {
  ClassMembersPage({this.auth, this.db, this.dojoClass});

  final BaseAuth auth;
  final Database db;
  final Class dojoClass;

  State<StatefulWidget> createState() => _ClassMembersPageState();
}

class _ClassMembersPageState extends State<ClassMembersPage> {
  String dojoId = "";
  List<Student> studentList = [];
  bool _loading = true;


  getStudents(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    List<ListTile> studentTiles = [];
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
        stu.description = studentInfo['description'];//editable
        //add email, uneditable, phone, also uneditable, up to you -AO

        studentList.add(stu);
        studentTiles.add(ListTile(
          title: Text(stu.first_name + " " + stu.last_name),
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
    });

    return studentTiles;
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
              child: Text('Add Members', style: TextStyle(fontSize: 20)),
              onPressed: goToAddMembers,
            ),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }

  void goToAddMembers() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddClassMembersPage(auth: widget.auth, db: widget.db, dojoClass: widget.dojoClass,),
        )
    );
  }
}

class AddClassMembersPage extends StatefulWidget {
  AddClassMembersPage({this.auth, this.db, this.dojoClass});

  final BaseAuth auth;
  final Database db;
  final Class dojoClass;

  State<StatefulWidget> createState() => _AddClassMembersPageState();
}

class _AddClassMembersPageState extends State<AddClassMembersPage> {
  String dojoId = "";
  List<Student> studentList = [];
  bool _loading = true;
  Map<String, bool>_isChecked = new Map();

  void addMembers () async {
    DocumentReference doc = Firestore.instance.collection('classes').document(widget.dojoClass.id);
    Map<String, String> members = widget.dojoClass.members;
    for (int i = 0; i < _isChecked.length; i++) {
      Student stu = studentList[i];
      if (_isChecked[stu.id]) {
        await Firestore.instance.collection('users').document(stu.id).collection('classes').document().setData({widget.dojoClass.id: true});
        members[stu.id] = stu.first_name + ' ' + stu.last_name;
      }
    }
    await doc.updateData({'members' : members});
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
              child: Text('Add Members', style: TextStyle(fontSize: 20)),
              onPressed: addMembers,
            ),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }

  getStudents(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    List<CheckboxListTile> studentTiles = [];
    snapshot.data.documents.forEach((document) {
      Map<String, dynamic> studentInfo = document.data;
      //if (eventInfo['accountType'] != 'Coach'){
      if (studentInfo['accountType'] != 'Coach' && widget.dojoClass.members[document.documentID] == null){
        Student stu = new Student();
        stu.id = document.documentID;
        stu.first_name = studentInfo['firstName'];//not editable
        stu.last_name = studentInfo['lastName'];//not editable
        stu.nickname = studentInfo['nickname'];//editable
        stu.dob = studentInfo['dob'];//definite not editable
        stu.status = studentInfo['accountType'];//editable
        stu.rank = studentInfo['rank'];//editable
        if (_isChecked[stu.id] == null) {
          _isChecked[stu.id] = false;
        }
        //add email, uneditable, phone, also uneditable, up to you -AO

        studentList.add(stu);
        print(stu.id);
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
}*/