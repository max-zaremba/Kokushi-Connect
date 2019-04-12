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
          stream: Firestore.instance.collection('users')
              .document(userId)
              .collection('channels')
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
    List<ListTile> channels = [];
    snapshot.data.documents.forEach((document) {
      channels.add(ListTile(title: Text(document.data.keys.first), onTap: () => moveToChatPage(document.data.keys.first),));
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