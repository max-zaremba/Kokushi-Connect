import 'package:flutter/material.dart';
import 'auth.dart';
import 'db_control.dart';

class ChannelsPage extends StatefulWidget {
  ChannelsPage({this.auth, this.db});
  final Auth auth;
  final Database db;

  @override
  State<StatefulWidget> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<ChannelsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}