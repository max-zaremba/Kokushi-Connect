import 'package:flutter/material.dart';
import 'package:kokushi_connect/auth.dart';

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
  int _month;
   List<DropdownMenuItem> months = [
     new DropdownMenuItem(value: 1, child: Text("January"),),
     new DropdownMenuItem(value: 2, child: Text("Febuary"),),
     new DropdownMenuItem(value: 3, child: Text("March"),),
     new DropdownMenuItem(value: 4, child: Text("April"),),
     new DropdownMenuItem(value: 5, child: Text("May"),),
     new DropdownMenuItem(value: 6, child: Text("June"),),
     new DropdownMenuItem(value: 7, child: Text("July"),),
     new DropdownMenuItem(value: 8, child: Text("August"),),
     new DropdownMenuItem(value: 9, child: Text("September"),),
     new DropdownMenuItem(value: 10, child: Text("October"),),
     new DropdownMenuItem(value: 11, child: Text("November"),),
     new DropdownMenuItem(value: 12, child: Text("December"),),
   ];
  int _day;
  int _year;

  @override
  Widget build(BuildContext context) {

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
        decoration: InputDecoration(labelText: _month.toString()),
        obscureText: true,
        validator: (value) => value.isEmpty? 'Last Name can\'t be empty' : null,
        onSaved: (value) => _lastName = value,
      ),

      DropdownButton(
          onChanged: (value) => _month = value,
          items: months,

      ),

    ];
  }
}