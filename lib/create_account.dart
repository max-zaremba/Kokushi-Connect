import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({this.auth, this.onSignedOut, this.db});
  final BaseAuth auth;
  final Database db;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  State<StatefulWidget> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();
  String _firstName;
  String _lastName;
  DateTime _dob;
  String _rank;
  bool _coach = false;

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy"),
    InputType.date: DateFormat('yyyy-MM-dd')
  };

  InputType inputType = InputType.both;
  bool editable = true;
  DateTime date;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
          //await widget.db.createAccount(_firstName, _lastName, _dob, _rank, true);
          //print('Woah it actually worked');
      await Firestore.instance.collection("users").document(await widget.auth.currentUser()).setData({ 'firstName': _firstName, 'lastName': _lastName, 'dob': _dob, 'rank': _rank, 'coach': false });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: widget._signOut,
          )
        ],
      ),

      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildInputs() + buildSubmitButtons()
            ),
          )
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'First name'),
        validator: (value) => value.isEmpty? '*Required' : null,
        onSaved: (value) => _firstName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Last name'),
        validator: (value) => value.isEmpty? '*Required' : null,
        onSaved: (value) => _lastName = value,
      ),
      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'Date of birth'),
        inputType: inputType,
        format: formats[inputType],
        editable: editable,
        onSaved: (value) => _dob = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rank'),
        validator: (value) => value.isEmpty? '*Required' : null,
        onSaved: (value) => _rank = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      RaisedButton(
        child: Text('Submit', style: TextStyle(fontSize: 20)),
        onPressed: validateAndSubmit,
      ),
    ];
  }
}