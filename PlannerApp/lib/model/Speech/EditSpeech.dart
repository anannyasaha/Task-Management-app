import 'package:flutter/material.dart';
class edit_speech extends StatefulWidget {
  String texttoedit;
  edit_speech({Key key,this.texttoedit}):super(key: key);
  _edit_speechState createState() => _edit_speechState();
}

class _edit_speechState extends State<edit_speech> {
  TextEditingController _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Edit text")),
      body:SingleChildScrollView(
        child:AlertDialog(
          content: TextField(
            controller: _controller,

          ),
        )
      )
    );
  }
  void initState() {
    super.initState();
    _controller.text=widget.texttoedit;
  }

  }
