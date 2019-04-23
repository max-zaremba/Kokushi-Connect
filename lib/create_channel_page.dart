import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

class Student {
  String id;
  String firstName;
  String lastName;

  Student(this.id, this.firstName, this.lastName);
}
class CreateChannelPage extends StatefulWidget {
  CreateChannelPage({this.auth, this.db});
  final Auth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _CreateChannelPage();
}

class _CreateChannelPage extends State<CreateChannelPage> {
  String _dojoId = '';
  String _userId = '';
  String _firstName = '';
  String _lastName = '';
  bool _loading = true;
  List<Student> _selected = new List<Student>();
  final TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getDojoId();
  }

  void getDojoId() async {
    _loading = true;
    _userId = await widget.auth.currentUser();
    _firstName = await widget.db.getFirstName(_userId);
    _lastName = await widget.db.getLastName(_userId);
    _dojoId = await widget.db.getUserDojo(_userId);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("New Group"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Done", style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                createChannel();
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            new Container(
              child: TextField(
                decoration: new InputDecoration.collapsed(
                    hintText: 'Enter a group name (optional)'
                ),
                controller: _textController,
              )
            ),
            Flexible(
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .where('dojoId', isEqualTo: _dojoId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text("Error!");
                    else if (!snapshot.hasData) return Text("No friends :(");
                    return ListView(children: getOtherUsers(snapshot),);
                  }
              ),
            ),
          ],
        ),
      );
    }
  }

  getOtherUsers(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ListTile> users = [];
    snapshot.data.documents.forEach((document) {
      if (document.documentID != _userId) {
        Student student = new Student(document.documentID, document.data['firstName'], document.data['lastName']);
        users.add(ListTile(
          title: Text(
            document.data['firstName'] + ' ' + document.data['lastName']),
          trailing: Icon(
            personSelected(student) ? Icons.check : null,
            color: Colors.blue,
          ),

          onTap: () {
            setState(() {
              if (personSelected(student))
                _selected.removeWhere((stu) => stu.id == student.id);
              else
                _selected.add(student);
              print(_selected);
            });
          },
        ));
      }
    });
    return users;
  }
  
  bool personSelected(Student student) {
    for (Student stu in _selected) {
      if (student.id == stu.id)
        return true;
    }
    return false;
  }

  void createChannel() async {
    if (_selected.isNotEmpty) {
      DocumentReference channelId = await Firestore.instance.collection('channels').add({'name': _textController.text});
      final Map<String, String> users = new Map<String, String>();
      users[_userId] = _firstName + ' ' + _lastName;
      for (Student user in _selected) {
        users[user.id] = user.firstName + ' ' + user.lastName;
        await Firestore.instance.collection('users').document(user.id).collection('channels').document().setData({channelId.documentID: true});
      }
      await Firestore.instance.collection('users').document(_userId).collection('channels').document().setData({channelId.documentID: true});
      await Firestore.instance.collection('channels').document(channelId.documentID).updateData({'members': users});
      moveToChatPage(channelId.documentID);
    }
  }

  void moveToChatPage(String channelId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(auth: widget.auth, db: widget.db, channelId: channelId,)),
    );
  }
}