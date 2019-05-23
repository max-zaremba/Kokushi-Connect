import 'package:flutter/material.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
import 'auth.dart';
import 'root_page.dart';
import 'db_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

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

class SettingsPage extends StatefulWidget {
  SettingsPage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;

  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String dojoId = "";
  bool _loading = true;

  final formKey = GlobalKey<FormState>();

  String _firstName;
  String _lastName;
  String _nickname;
  DateTime _dob;
  TextEditingController _nicknameController;
  Student stu = new Student();

  @override
  SettingsPage get widget => super.widget;

  @override
  void initState() {
    super.initState();
    getStudent();

  }

  void getStudent() async {
    final Firestore _firestore = Firestore.instance;
    String userId = await widget.auth.currentUser();
    print("Current user $userId");
    /*QuerySnapshot docs = await Firestore.instance.collection('dojos').document(dojoId).collection('members').getDocuments();
    docs.documents.forEach((document) async {

    });
    print("in getDojoId after for each: students: $students");*/
    DocumentSnapshot document = await _firestore.collection('users').document(userId).get();
    Map<String, dynamic> studentInfo = document.data;

    stu.id = document.documentID;
    stu.first_name = studentInfo['firstName'];
    stu.last_name = studentInfo['lastName'];
    stu.nickname = studentInfo['nickname'];
    stu.dob = studentInfo['dob'];
    stu.status = studentInfo['accountType'];
    stu.rank = studentInfo['rank'];
    stu.description = studentInfo['description'];

    _nicknameController = new TextEditingController(text: stu.nickname);

    setState(() {
      _loading = false;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    try {
      String userId = stu.id;
      DocumentReference doc = Firestore.instance.collection('users').document(userId);
      if(_firstName != await widget.db.getFirstName(userId)){
        await doc.updateData({'firstName' : _firstName});
        print("first name changed.");
      }
      if(_lastName != await widget.db.getLastName(userId)){
        await doc.updateData({'lastName' : _lastName});
        print("last name changed.");
      }
      if(_nickname != await widget.db.getNickname(userId)){
        await doc.updateData({'nickname' : _nickname});
        print("nickname changed.");
      }
//      if(_dob != await widget.db.getDOB(userId)){
//        await doc.updateData({'nickname' : _nickname});
//        print("dob changed.");
//      }
    }
    catch (e) {
      print('Error: $e');
    }
  }

  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text("Settings"),
          context: context,
          auth: widget.auth,
          db: widget.db
        ),
        body: Center(
          child: Container(
            child: ListView(
              children: <Widget>[

                Padding(
                    padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                    child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Text('First Name')),
                          Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                onSaved: (value) => _firstName = value,
                                initialValue: stu.first_name,
                              )
                          )
                        ]
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                    child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Text('Last Name')),
                          Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                                onSaved: (value) => _lastName = value,
                                initialValue: stu.last_name,
                              )
                          )
                        ]
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                    child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Text('Nickname')),
                          Expanded(
                              child: TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  onChanged: (value){ setState(() { _nickname = value; }); },
                                  controller: _nicknameController
                              )
                          )
                        ]
                    )
                ),

                  //need to fix/edit this
//                Padding(
//                    padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
//                    child: Row(
//                        children: [
//                          DateTimePickerFormField(
//                            decoration: InputDecoration(labelText: 'Start Date and Time'),
//                            inputType: InputType.date,
//                            format: DateFormat("MMMM d, yyyy"),
//                            onSaved: (value) => _dob = value,
//                            initialValue: stu.dob,
//                          )
//                        ]
//                    )
//                ),

                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        child: Text(
                            'Save Changes', style: TextStyle(fontSize: 20)),
                        onPressed: validateAndSubmit,
                      ),
                    )
                )
              ]
            )
          )
        )
      );
    }
}
}