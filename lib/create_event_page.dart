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
  DateTime _date = DateTime.now();
  String _title;
  String _description;
  DateTime _time = DateTime.now();
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
    try {
      _date = new DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
      final String userId = await widget.auth.currentUser();
      final String dojoId = await widget.db.getDojoIdByUserId(userId);
      await widget.db.createEvent(_date, _title, _description, userId, dojoId);
    }
    catch (e) {
      print('Error: $e');
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
   bool showDateTimePicker = true;
   if (widget.date != null) {
     _date = widget.date;
     showDateTimePicker = false;
   }

   return[
      Visibility (
        child: DateTimePickerFormField(
          decoration: InputDecoration(labelText: 'Date'),
          inputType: inputTypeDate,
          format: DateFormat('yyyy-MM-dd'),
          onSaved: (value) => _date = value,
        ),
        visible: showDateTimePicker,
      ),
      Visibility (
        child: Text("Date\n" + _date.year.toString() + "-" + _date.month.toString().padLeft(1, "0") + "-" + _date.day.toString().padLeft(1, "0")),
        visible: !showDateTimePicker,
      ),
      DateTimePickerFormField(
        decoration: InputDecoration(labelText: 'Time'),
        inputType: inputTypeTime,
        format: DateFormat("HH:mm"),
        onSaved: (value) => _time = value,
      ),
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

}