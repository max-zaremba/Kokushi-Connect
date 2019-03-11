import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:kokushi_connect/create_dojo_page.dart';
import 'package:kokushi_connect/join_dojo_page.dart';
import 'root_page.dart';
import 'db_control.dart';

class CreateUserPage extends StatefulWidget {
  CreateUserPage({this.auth, this.db});
  final BaseAuth auth;
  final Database db;
  
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
    DropdownMenuItem<String>(child: Text("White"), value: "White"),
    DropdownMenuItem<String>(child: Text("Yellow"), value: "Yellow"),
    DropdownMenuItem<String>(child: Text("Orange"), value: "Orange"),
    DropdownMenuItem<String>(child: Text("Green"), value: "Green"),
    DropdownMenuItem<String>(child: Text("Blue"), value: "Blue"),
    DropdownMenuItem<String>(child: Text("Purple"), value: "Purple"),
    DropdownMenuItem<String>(child: Text("Brown, Sankyu"), value: "Sankyu"),
    DropdownMenuItem<String>(child: Text("Brown, Nikyu"), value: "Nikyu"),
    DropdownMenuItem<String>(child: Text("Brown, Ikkyu"), value: "Ikkyu"),
    DropdownMenuItem<String>(child: Text("Black, Shodan"), value: "Shodan"),
    DropdownMenuItem<String>(child: Text("Black, Nidan"), value: "Nidan"),
    DropdownMenuItem<String>(child: Text("Black, Sandan"), value: "Sandan"),
    DropdownMenuItem<String>(child: Text("Black, Yodan"), value: "Yodan"),
    DropdownMenuItem<String>(child: Text("Black, Godan"), value: "Godan"),
    //anything below this line is really rare, prolly not gonna have any of these on the app
    DropdownMenuItem<String>(child: Text("Black, Rokudan"), value: "Rokudan"),
    DropdownMenuItem<String>(child: Text("Black, Shichidan"), value: "Shichidan"),
    DropdownMenuItem<String>(child: Text("Black, Hachidan"), value: "Hachidan"),
    DropdownMenuItem<String>(child: Text("Black, Kudan"), value: "Kudan"),
    DropdownMenuItem<String>(child: Text("Black, Judan"), value: "Judan")
  ];
  String _accountType = "Student";
  InputType inputType = InputType.date;

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
      try {
        String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
        await widget.db.createAccount(_firstName, _lastName, _dob, _belt, _accountType, userId);
      }
      catch (e) {
        print('Error: $e');
      }
    }
  }

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
          )
        ),
      ),
    );
  }

  void moveToCreateDojo() {
    validateAndSubmit();
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return MaterialApp(
                home: CreateDojoPage(auth: widget.auth, db: widget.db),
              );
            }
        )
    );
  }

  void moveToJoinDojo() {
    validateAndSubmit();
    if (validateAndSave()) {
      Navigator.of(context).push(
          new MaterialPageRoute(
              builder: (BuildContext context) {
                return MaterialApp(
                  home: JoinDojoPage(auth: widget.auth),
                );
              }
          )
      );
    }
  }

  void moveToLogin() {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return MaterialApp(
                home: RootPage(auth: widget.auth, db: widget.db,),
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
            value: "Student",
            groupValue: _accountType,
            onChanged: (value) { setState(() { _accountType = value; }); },
          ),
          RadioListTile<String>(
            title: const Text('Coach'),
            value: "Coach",
            groupValue: _accountType,
            onChanged: (value) { setState(() { _accountType = value; });
            },
          )
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


        visible: (_accountType == "Coach"),

      ),
      FlatButton(
        child: Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
        onPressed: moveToLogin,
      )
    ];
  }
}