import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:kokushi_connect/create_dojo_page.dart';
import 'package:kokushi_connect/join_dojo_page.dart';
import 'package:kokushi_connect/login_page.dart';

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
  String _belt;
  List<DropdownMenuItem<String>> belts = [
    DropdownMenuItem<String>(child: Text("White Belt"), value: "White"),
    DropdownMenuItem<String>(child: Text("Black Belt"), value: "Black"),
  ];
  String _coach = "student";

  InputType inputType = InputType.date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),

      body: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: buildInputs()
            ),
          )
      ),
    );
  }

  void moveToCreateDojo() {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return MaterialApp(
                home: CreateDojoPage(auth: Auth()),
              );
            }
        )
    );
  }

  void moveToJoinDojo() {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return MaterialApp(
                home: JoinDojoPage(auth: Auth()),
              );
            }
        )
    );
  }

  void moveToLogin() {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return MaterialApp(
                home: LoginPage(auth: Auth()),
              );
            }
        )
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
        textCapitalization: TextCapitalization.sentences,
        validator: (value) => value.isEmpty? 'First Name can\'t be empty' : null,
        onSaved: (value) => _firstName = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: "Last Name"),
        textCapitalization: TextCapitalization.sentences,
        validator: (value) => value.isEmpty? 'Last Name can\'t be empty' : null,
        onSaved: (value) => _lastName = value,
      ),

      DateTimePickerFormField(
          decoration: InputDecoration(labelText: 'Date of birth'),
          inputType: inputType,
          format: DateFormat('yyyy-MM-dd'),
          onSaved: (value) => _dob = value,
      ),

      DropdownButton(
        isExpanded: true,
        iconSize: 40,
        hint: Text("Choose Belt"),
        value: _belt,
        onChanged: (value){ setState(() { _belt = value; }); },
        items: belts,
      ),

      Column(
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('Student'),
            value: "student",
            groupValue: _coach,
            onChanged: (value) { setState(() { _coach = value; }); },
          ),
          RadioListTile<String>(
            title: const Text('Coach'),
            value: "coach",
            groupValue: _coach,
            onChanged: (value) { setState(() { _coach = value; }); },
          ),
        ],
      ),
      RaisedButton(
        child: Text('Join Dojo', style: TextStyle(fontSize: 20)),
        onPressed: moveToJoinDojo,
      ),
      Visibility(
        child: RaisedButton(
          child: Text('Create Dojo', style: TextStyle(fontSize: 20)),
          onPressed: moveToCreateDojo,
        ),
        visible: (_coach == "coach"),
      ),
      FlatButton(
        child: Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
        onPressed: moveToLogin,
      )
    ];
  }
}