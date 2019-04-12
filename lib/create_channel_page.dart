import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getDojoId();
  }

  void getDojoId() async {
    _loading = true;
    _userId = await widget.auth.currentUser();
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
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }
            )
          ],
        ),
        body: StreamBuilder(
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
      );
    }
  }

  getOtherUsers(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<ListTile> users = [];
    snapshot.data.documents.forEach((document) {
      if (document.documentID != _userId)
        users.add(ListTile(title: Text(document.data['firstName'] + ' ' + document.data['lastName']),));
    });
    return users;

  }
}