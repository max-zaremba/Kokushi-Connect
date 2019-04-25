import 'package:flutter/material.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:kokushi_connect/base_page.dart';
import 'db_control.dart';
import 'custom_app_bar.dart';
import 'home_page.dart';
import 'create_dojo_page.dart';

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
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      widget.db.getAccountType(userId).then((accountType) {
        if (accountType == "Coach") {
          setState(() {
            _visible = true;
          });
        } else {
          setState(() {
            _visible = false;
          });
        }
      });
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<bool> validateAndSubmit() async {
    try {
      String dojoId = await widget.db.getDojoIdByDojoCode(_dojoCode);
      if (dojoId != null) {
        await widget.db.setUserDojo(dojoId, await widget.auth.currentUser());
        return true;
      }
    }
    catch (e) {
      print('Error: $e');
    }
    return false;
  }

  void joinDojo() async {
    if (validateAndSave()) {
      bool dojoExists = await validateAndSubmit();
      if (dojoExists) {
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BasePage(auth: widget.auth, db: widget.db),
            )
        );
      }
    }
  }

  void moveToCreateDojo() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CreateDojoPage(auth: widget.auth, db: widget.db),
        )
    );
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
                  Visibility(
                    visible: (_visible),
                    child: FlatButton(
                      child: Text('Create Dojo', style: TextStyle(fontSize: 20)),
                      onPressed: moveToCreateDojo,
                    ),
                  ),
                ]
            ),
          )
      ),
    );
  }

}