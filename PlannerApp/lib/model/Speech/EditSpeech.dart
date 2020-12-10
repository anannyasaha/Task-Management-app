import 'package:flutter/material.dart';

import 'Speechmodel.dart';
import 'speech.dart';
class edit_speech extends StatefulWidget {
  String texttoedit;
  int id;
  edit_speech({Key key,this.texttoedit,this.id}):super(key: key);
  _edit_speechState createState() => _edit_speechState();
}

class _edit_speechState extends State<edit_speech> {
  TextEditingController _controller=TextEditingController();
  Speechmodel speechmodel=new Speechmodel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Edit text"),
          actions: [
            IconButton(
              icon:Icon(Icons.add),
              onPressed: (){
                if(widget.id==-1)
                addspeech(_controller.text);
                else
                  editspeech(_controller.text,widget.id);
              },
            )
          ],

      ),
      body:SingleChildScrollView(
        child:AlertDialog(
          content: TextField(
            controller: _controller,
            maxLines: null,
          ),
        )
      )
    );
  }
  void initState() {
    super.initState();
    _controller.text=widget.texttoedit;
  }
  void addspeech(String text){
    speech speechadd=new speech(text);
    speechmodel.insertspeech(speechadd);
  }
  void editspeech(String text,int id){
    speech speechupdate=new speech(text);
    speechmodel.updatespeech(speechupdate);
  }

  }
