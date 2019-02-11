import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateUserPage extends StatefulWidget {
  CreateUserPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  DateTime _dob;
  bool _coach;

  InputType inputType = InputType.date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),

      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildInputs()
            ),
          )
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: 'First Name'),
        validator: (value) => value.isEmpty? 'First Name can\'t be empty' : null,
        onSaved: (value) => _firstName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Last Name"),
        obscureText: true,
        validator: (value) => value.isEmpty? 'Last Name can\'t be empty' : null,
        onSaved: (value) => _lastName = value,
      ),

      DateTimePickerFormField(
          decoration: InputDecoration(
              labelText: 'Date of birth'
          ),
          inputType: inputType,
          format: DateFormat('yyyy-MM-dd'),
          onSaved: (value) => _dob = value,
      ),

      Column(
        children: <Widget>[
          RadioListTile<bool>(
            title: const Text('Student'),
            value: false,
            groupValue: _coach,
            onChanged: (value) { setState(() { _coach = value; }); },
          ),
          RadioListTile<bool>(
            title: const Text('Coach'),
            value: true,
            groupValue: _coach,
            onChanged: (value) { setState(() { _coach = value; }); },
          ),
        ],
      ),
      RaisedButton(
        child: Text('Join Dojo', style: TextStyle(fontSize: 20)),
        onPressed: null,
      ),
      Visibility(
        child: RaisedButton(
          child: Text('Create Dojo', style: TextStyle(fontSize: 20)),
          onPressed: null,
        ),
        visible: _coach,
      ),
    ];
  }
}