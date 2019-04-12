import 'package:flutter/material.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
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
    print("Current dojo $dojoId");
    /*QuerySnapshot docs = await Firestore.instance.collection('dojos').document(dojoId).collection('members').getDocuments();
    docs.documents.forEach((document) async {
      
    });
    print("in getDojoId after for each: students: $students");*/
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
          appBar: CustomAppBar(
            title: Text('Student Info'),
            context: context,
            auth: widget.auth,
            db: widget.db,
          ),
          body: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .where('dojoId', isEqualTo: dojoId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text("Error!");
              else if (!snapshot.hasData) return Text("No Students");
              return ListView(children: getStudents(snapshot),);
            },
          )
        );
        /*return Scaffold(
          appBar: CustomAppBar(
            title: Text('Student Info'),
            context: context,
            auth: widget.auth,
            db: widget.db,
          ),
          body: ListView(children: getStudents(),)
        );*/
    }
  }

  getStudents(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    print(students);
    print("students: $students");

    List<ListTile> stuTiles = [];

    snapshot.data.documents.forEach((document) {
      Map<String, dynamic> studentInfo = document.data;
      if (studentInfo['accountType'] != 'Coach'){
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

        students.add(stu);
        stuTiles.add(ListTile(
              title: Text(studentInfo['firstName'] + " " + studentInfo['lastName']),
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
    
    return stuTiles;
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
  final formKey = GlobalKey<FormState>();

  @override
  InfoPage get widget => super.widget;

  String _belt;
  String _status;
  String _firstName;
  String _lastName;
  String _nickname;
  String _description;

  var _studentStatuses = ['Student', 'Assistant Instructor'];
  var _ranks = [
    DropdownMenuItem<String>(child: Text("White"), value: "White"),
    DropdownMenuItem<String>(child: Text("Yellow"), value: "Yellow"),
    DropdownMenuItem<String>(child: Text("Orange"), value: "Orange"),
    DropdownMenuItem<String>(child: Text("Green"), value: "Green"),
    DropdownMenuItem<String>(child: Text("Blue"), value: "Blue"),
    DropdownMenuItem<String>(child: Text("Purple"), value: "Purple"),
    DropdownMenuItem<String>(child: Text("Brown, Sankyu"), value: "Sankyu"),
    DropdownMenuItem<String>(child: Text("Brown, Nikyu"), value: "Nikyu"),
    DropdownMenuItem<String>(child: Text("Brown, Ikkyu"), value: "Ikkyu"),
    DropdownMenuItem<String>(child: Text("Black, Shodan"), value: "Shodan"),
    DropdownMenuItem<String>(child: Text("Black, Nidan"), value: "Nidan"),
    DropdownMenuItem<String>(child: Text("Black, Sandan"), value: "Sandan"),
    DropdownMenuItem<String>(child: Text("Black, Yodan"), value: "Yodan"),
    DropdownMenuItem<String>(child: Text("Black, Godan"), value: "Godan"),
    //anything below this line is really rare, prolly not gonna have any of these on the app
    DropdownMenuItem<String>(child: Text("Black, Rokudan"), value: "Rokudan"),
    DropdownMenuItem<String>(child: Text("Black, Shichidan"), value: "Shichidan"),
    DropdownMenuItem<String>(child: Text("Black, Hachidan"), value: "Hachidan"),
    DropdownMenuItem<String>(child: Text("Black, Kudan"), value: "Kudan"),
    DropdownMenuItem<String>(child: Text("Black, Judan"), value: "Judan")
  ];

  int calculateAge() {
    Duration dur = DateTime.now().difference(widget.student.dob);
    int diff = (dur.inDays/365).floor();
    return diff;
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
      String userId = await widget.auth.currentUser();
      DocumentReference doc = Firestore.instance.collection('users').document(userId);
      //remove edit access for first and last name
      if(_firstName != await widget.db.getFirstName(userId)){
        await doc.setData({'firstName' : _firstName});
      }
      if(_lastName != await widget.db.getLastName(userId)){
        await doc.setData({'lastName' :_lastName});
      }
      if(_nickname != await widget.db.getNickname(userId)){
        await doc.setData({'nickname' : _nickname});
      }
      if(_description != await widget.db.getDescription(userId)){
        await doc.setData({'description' : _description});
      }
      if(_belt != await widget.db.getRank(userId)){
        await doc.setData({'rank' : _belt});
      }
      if(_status != await widget.db.getAccountType(userId)){
        await doc.setData({'accountType' :_status});
      }
    }
    catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Text(widget.student.first_name + ' ' + widget.student.last_name),
          context: context,
          auth: widget.auth,
          db: widget.db,
        ),
        body: Center(
          child: Container(
              child: ListView(
                  children: <Widget>[
                    //first name
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
                                )
                            )
                          ]
                      )
                    ),

                    //last name
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
                                  )
                              )
                            ]
                        )
                    ),

                    //nickname
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                      child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: Text('Nickname')),
                            Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                  ),
                                  onSaved: (value) => _nickname = value,
                                )
                            )
                          ]
                      )
                    ),

                    //age
                    Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                            child: Text('Age: ' +
                                calculateAge().toString())
                        )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: Text('Status:')),
                            DropdownButton<String>(
                                items: _studentStatuses.map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(dropDownStringItem)
                                  );
                                }).toList(),

                                value: _status,
                                onChanged: (value){ setState(() { _status = value; }); }
                            )
                          ]
                      )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                            padding: EdgeInsets.only(right: 15.0),
                              child: Text('Rank:')),
                            DropdownButton(
                              value: _belt,
                              onChanged: (value){ setState(() { _belt = value; }); },
                              items: _ranks,
                            ),
                          ]
                      )
                    ),

                    //note
                    Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.only(bottom: 10.0, right: 10.0, left: 10.0),
                        child: TextFormField(
                            maxLines: 15,
                            decoration: InputDecoration(
                              hintText: "additional info...",
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) => _description = value,
                        )
                    ),

                    Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
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
  }}
