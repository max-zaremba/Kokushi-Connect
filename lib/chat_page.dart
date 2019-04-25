import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _name = "Your name";

class ChatPage extends StatefulWidget {
  ChatPage({this.auth, this.db, this.channelId});
  final Auth auth;
  final Database db;
  final String channelId;

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool _isComposing = false;
  String _userId = '';
  String _firstName = '';
  String _lastName = '';
  var listMessage;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    String userId = await widget.auth.currentUser();
    String firstName = await widget.db.getFirstName(userId);
    String lastName = await widget.db.getLastName(userId);

    _firstName = firstName;
    _lastName = lastName;
    setState(() {
      _userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, child: null,
          )],
        title: Text("Messages"),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('channels')
                  .document(widget.channelId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: new EdgeInsets.symmetric(vertical: 8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => ChatMessage(
                      text: listMessage[index].data['content'],
                      animationController: new AnimationController(
                        duration: new Duration(milliseconds: 700),
                        vsync: this,
                      ),
                      firstName: listMessage[index].data['firstName'],
                      lastName: listMessage[index].data['lastName'],
                      messageColor: listMessage[index].data['userId'] == _userId ? Colors.blue.shade50 : Colors.white,
                    ),
                    itemCount: listMessage.length,
                    controller: listScrollController,
                  );
                }
              }
            ),
            /*child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),*/
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    print(widget.channelId);

    var documentReference = Firestore.instance.collection('channels').document(widget.channelId).collection('messages').document(DateTime.now().millisecondsSinceEpoch.toString());

    print("firstName $_firstName");
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'userId': _userId,
          'firstName': _firstName,
          'lastName': _lastName,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': text,
          'type': 0
        },
      );
    });

    listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

    /*ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
    */
  }

  /*@override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }*/
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.firstName, this.lastName, this.messageColor});
  final String text;
  final AnimationController animationController;
  final String firstName;
  final String lastName;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: messageColor,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0, left: 4.0),
            child: new CircleAvatar(child: new Text(firstName[0] + lastName[0])),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: new Text(firstName + ' ' + lastName, style: TextStyle(color: Colors.black54),)),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}