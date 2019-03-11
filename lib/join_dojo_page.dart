import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';
import 'root_page.dart';
import 'globals.dart';

class JoinDojoPage extends StatefulWidget {
  JoinDojoPage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _JoinDojoPageState();
}

class _JoinDojoPageState extends State<JoinDojoPage> {
  final formKey = GlobalKey<FormState>();
  String _dojoCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Join Dojo'),
        context: context,
        auth: widget.auth,
      ),

      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Dojo Code'),
                    validator: (value) => value.isEmpty? 'Dojo Code can\'t be empty' : null,
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