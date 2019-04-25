import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
import 'package:kokushi_connect/db_control.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateClassPage extends StatefulWidget {
  CreateClassPage({this.auth, this.db});

  final BaseAuth auth;
  final Database db;

  State<StatefulWidget> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {

  final formKey = GlobalKey<FormState>();
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _repeatUntil = DateTime.now().add(new Duration(days: 30));
  String _title;
  String _description;
  List<bool> _daysOfWeek = [false, false, false, false, false, false, false];
  InputType inputTypeDate = InputType.date;
  InputType inputTypeTime = InputType.time;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    DateTime currentDay = await _startTime;
    while (_repeatUntil.isAfter(currentDay)) {
      print("c: " + currentDay.weekday.toString());
      print("s: " + _startTime.day.toString());
      print("e: " + _endTime.day.toString());
      if (_daysOfWeek[currentDay.weekday % 7]) {
        try {
          final String userId = await widget.auth.currentUser();
          final String dojoId = await widget.db.getDojoIdByUserId(userId);
          await widget.db.createEvent(
              _startTime, _endTime, _title, _description, userId, dojoId);
        }
        catch (e) {
          print('Error: $e');
        }
      }
      currentDay = await currentDay.add(new Duration(days: 1));
      _startTime = await _startTime.add(new Duration(days: 1));
      _endTime = await _endTime.add(new Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Calendar'),
        context: context,
        auth: widget.auth,
        db: widget.db,
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

  void createEvent() async {
    if (validateAndSave()) {
      await validateAndSubmit();
      Navigator.pop(context);
    }
  }

  List<Widget> buildInputs () {
    return[
      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'Start Date and Time'),
        inputType: InputType.both,
        format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
        onSaved: (value) => _startTime = value,
        initialValue: _startTime,
      ),

      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'End Date and Time'),
        inputType: InputType.both,
        format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
        onSaved: (value) => _endTime = value,
      ),

      Text("\nRepeat", style: new TextStyle(fontSize: 18),),
      repeatRow(),

      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'Repeat Until'),
        inputType: InputType.both,
        format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
        onSaved: (value) => _repeatUntil = value,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: 'Class Name'),
        validator: (value) => value.isEmpty? 'Title can\'t be empty' : null,
        onSaved: (value) => _title = value,
      ),

      TextFormField(
        decoration: InputDecoration(labelText: "Description"),
        onSaved: (value) => _description = value,
      ),

      RaisedButton(
        child: Text('Create Event', style: TextStyle(fontSize: 20)),
        onPressed: createEvent,
      ),
    ];
  }

  Widget repeatRow () {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      new Flexible (child: CheckboxListTile(
        title: Text('S'),
        value: _daysOfWeek[0],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[0] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('M'),
        value: _daysOfWeek[1],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[1] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('T'),
        value: _daysOfWeek[2],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[2] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('W'),
        value: _daysOfWeek[3],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[3] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('T'),
        value: _daysOfWeek[4],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[4] = newValue;
          });
        },
      )),

      new Flexible(child: CheckboxListTile(
        title: Text('F'),
        value: _daysOfWeek[5],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[5] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('S'),
        value: _daysOfWeek[6],
        onChanged: (bool newValue) {
          setState(() {
            _daysOfWeek[6] = newValue;
          });
        },
      )),
    ]);
  }

}