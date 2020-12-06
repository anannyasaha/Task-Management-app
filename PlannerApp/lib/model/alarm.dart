import 'package:flutter/material.dart';

class alarm extends StatefulWidget {
  String alarmTitle;

  alarm({Key key, this.alarmTitle}) : super(key: key);

  @override
  _alarmState createState() => _alarmState();
}

class _alarmState extends State<alarm> {
  int time;

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         
        },
        tooltip: 'test alarm',
        child: Icon(Icons.lock_clock),
      ),
    );
  }
}
