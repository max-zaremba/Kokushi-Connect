import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';

class CreateDojoPage extends StatefulWidget {
  CreateDojoPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _CreateDojoPageState();
}

class _CreateDojoPageState extends State<CreateDojoPage> {

  final formKey = GlobalKey<FormState>();
  String _dojoName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Dojo'),
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
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) => value.isEmpty? 'Name can\'t be empty' : null,
                    onSaved: (value) => _dojoName = value,
                  ),

                  RaisedButton(
                    child: Text('Create Dojo', style: TextStyle(fontSize: 20)),
                    onPressed: null,
                  ),
                ]
            ),
          )
      ),
    );
  }

}