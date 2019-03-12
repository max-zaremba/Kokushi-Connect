import 'package:flutter/material.dart';
import 'package:kokushi_connect/auth.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';
import 'home_page.dart';

class JoinDojoPage extends StatefulWidget {
  JoinDojoPage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;

  final formKey = GlobalKey<FormState>();

  @override
  State<StatefulWidget> createState() => _JoinDojoPageState();
}

class _JoinDojoPageState extends State<JoinDojoPage> {
  final formKey = GlobalKey<FormState>();
  String _dojoCode;
  bool dojoExists = false;

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
      String dojoId = await widget.db.getDojoIdByDojoCode(_dojoCode);
      if (dojoId != null) {
        dojoExists = true;
        await widget.db.setUserDojo(dojoId, await widget.auth.currentUser());
      }
    }
    catch (e) {
      print('Error: $e');
    }
  }

  void joinDojo() {
    if (validateAndSave()) {
      validateAndSubmit();
      if (dojoExists) {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) {
                  return MaterialApp(
                    //TODO CreateHomePage
                    home: HomePage(auth: widget.auth),
                  );
                }
            )
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Join Dojo'),
        context: context,
        auth: widget.auth,
        db: widget.db,
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
                    onPressed: joinDojo,
                  ),
                ]
            ),
          )
      ),
    );
  }

}