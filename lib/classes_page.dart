import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:kokushi_connect/class_page.dart';
import 'package:kokushi_connect/create_class_page.dart';
import 'package:kokushi_connect/create_event_page.dart';
import 'package:kokushi_connect/event_page.dart';
import 'auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';

class ClassesPage extends StatefulWidget {
  ClassesPage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;

  State<StatefulWidget> createState() => _ClassesPageState();
}

class Class {
  String id;
  String name;
  String description;
  String userId;
  Map <String, String> members;

  Class();
}

class _ClassesPageState extends State<ClassesPage>{
  @override

  String dojoId = "";
  List<Class> classList = [];
  bool _loading = true;


  getClasses(AsyncSnapshot<QuerySnapshot> snapshot) {
    print("Get students called");
    List<ListTile> classTiles = [];
    snapshot.data.documents.forEach((document) {
      print("DOCUMENT: ${document.data}");
      Map<String, dynamic> classInfo = document.data;
      //if (classInfo['accountType'] != 'Coach'){
      Class dojoClass = new Class();
      dojoClass.id = document.documentID;
      dojoClass.name = classInfo['name']; //editable
      dojoClass.userId = classInfo['instructor']; //definite not editable
      dojoClass.description = classInfo['description'];
      if (classInfo['members'] != null)
        dojoClass.members = Map.from(classInfo['members']);//editable
      //add email, uneditable, phone, also uneditable, up to you -AO
      //}
      classList.add(dojoClass);
      if (true) {
        classTiles.add(new ListTile(
          title: Text(dojoClass.name),
          onTap: () {
            moveToClassPage(dojoClass);
          },
        ));
      }
    });

    return classTiles;
  }

  void moveToClassPage(Class dojoClass) {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ClassPage(auth: widget.auth, db: widget.db, dojoClass: dojoClass,),
        )
    );
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
          title: Text("Classes"),
          context: context,
          auth: widget.auth,
          db: widget.db,
        ),

        body: Container(
          child: Column(children: [
            new Expanded(child: StreamBuilder(
              stream: Firestore.instance
                  .collection('classes')
                  .where('dojoId', isEqualTo: dojoId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Text("Error!");
                else if (!snapshot.hasData) return Text("No Students");
                return ListView(children: getClasses(snapshot),);
              },
            )),
            RaisedButton(
              child: Text('Create New Class', style: TextStyle(fontSize: 20)),
              onPressed: moveToCreateClassPage,

            ),
          ]),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
      );
    }
  }

  void moveToCreateClassPage() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateClassPage(auth: widget.auth, db: widget.db),
        )
    );
  }
}