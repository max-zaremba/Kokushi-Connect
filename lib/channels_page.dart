import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';
import 'create_channel_page.dart';

class ChannelsPage extends StatefulWidget {
  ChannelsPage({this.auth, this.db});
  final Auth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _ChannelsPage();
}

class _ChannelsPage extends State<ChannelsPage> {
  bool _loading = true;
  String userId = "";


  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((id) {
      userId = id;
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return CircularProgressIndicator();
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateChannelPage(auth: widget.auth, db: widget.db)),
              ),
            )
          ],
          title: Text("Chat"),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('channels')
              .where('members.$userId', isGreaterThan: '')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text("Error!");
            else if (!snapshot.hasData) return Text("No chats yet :(");
            return ListView(children: getChannels(snapshot),);
          },
        ),
      );
    }
  }

  getChannels(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> channels = [];
    snapshot.data.documents.forEach((document) {
      String groupName = '';
      if (document.data['name'] != '')
        groupName = document.data['name'];
      else {
        Map<String, String> users = Map.from(document.data['members']);
        int numUsers = users.length - 1;
        users.forEach((uId, name) {
          if (uId != userId) {
            groupName += name;
            if (numUsers > 2)
              groupName += ', ';
            numUsers--;
            if (numUsers == 1)
              groupName += ' & ';
          }
        });
      }
      if(channels.isNotEmpty) {
        channels.add(Divider());
      }
      channels.add(ListTile(title: Text(groupName), onTap: () => moveToChatPage(document.documentID),));
    });
    return channels;
  }

  void moveToChatPage(String channelId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(auth: widget.auth, db: widget.db, channelId: channelId,)),
    );
  }
}