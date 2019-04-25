import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kokushi_connect/auth.dart';
import 'package:kokushi_connect/custom_app_bar.dart';
import 'package:kokushi_connect/db_control.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateEventPage extends StatefulWidget {
  CreateEventPage({this.auth, this.db, this.date});

  final BaseAuth auth;
  final Database db;
  final DateTime date;

  State<StatefulWidget> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {

  final formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTime _repeatUntil;
  String _title;
  String _description;
  List<bool> _repeats = [false, false, false, false, false, false, false];
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
    DateTime currentDay = _startDate;
    while (_repeatUntil.isAfter(currentDay)) {
      try {
        final String userId = await widget.auth.currentUser();
        final String dojoId = await widget.db.getDojoIdByUserId(userId);
        await widget.db.createEvent(_startDate, _endDate, _title, _description, userId, dojoId);
      }
      catch (e) {
        print('Error: $e');
      }
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

  void createEvent() {
    if (validateAndSave()) {
      validateAndSubmit();
      Navigator.pop(context);
    }
  }

  List<Widget> buildInputs () {
   if (widget.date != null) {
     _startDate = widget.date;
   }

   return[
      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'Start Date and Time'),
        inputType: InputType.both,
        format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
        onSaved: (value) => _startDate = value,
        initialValue: _startDate,
      ),

      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'End Date and Time'),
        inputType: InputType.both,
        format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
        onSaved: (value) => _endDate = value,
      ),

      Text("\nRepeat", style: new TextStyle(fontSize: 18),),
      repeatRow(),

      TextFormField(
        decoration: InputDecoration(labelText: 'Title'),
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
        value: _repeats[0],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[0] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('M'),
        value: _repeats[1],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[1] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('T'),
        value: _repeats[2],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[2] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('W'),
        value: _repeats[3],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[3] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('T'),
        value: _repeats[4],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[4] = newValue;
          });
        },
      )),

      new Flexible(child: CheckboxListTile(
        title: Text('F'),
        value: _repeats[5],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[5] = newValue;
          });
        },
      )),

      new Flexible (child: CheckboxListTile(
        title: Text('S'),
        value: _repeats[6],
        onChanged: (bool newValue) {
          setState(() {
            _repeats[6] = newValue;
          });
        },
      )),
    ]);
  }

}