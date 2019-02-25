import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';

class JoinDojoPage extends StatefulWidget {
  JoinDojoPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _JoinDojoPageState();
}

class _JoinDojoPageState extends State<JoinDojoPage> {
  final formKey = GlobalKey<FormState>();
  String _dojoCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Dojo'),
      ),

      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) => value.isEmpty? 'Email can\'t be empty' : null,
                    onSaved: (value) => _dojoCode = value,
                  ),

                  RaisedButton(
                    child: Text('Join Dojo', style: TextStyle(fontSize: 20)),
                    onPressed: null,
                  ),
                ]
            ),
          )
      ),
    );
  }

}