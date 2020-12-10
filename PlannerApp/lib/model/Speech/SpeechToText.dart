import 'package:PlannerApp/model/Speech/EditSpeech.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'Speechmodel.dart';
import 'speech.dart';

class SpeechText extends StatefulWidget {
  String title;
  SpeechText({Key key,this.title}):super(key: key);

  @override
  _SpeechTextState createState() => _SpeechTextState();
}

class _SpeechTextState extends State<SpeechText> {
  stt.SpeechToText _speech;
  bool _isListenning=false;
  String _text="Press the button and start speaking";
  double _confidence=1.0;
  final Map<String,HighlightedWord> _highlights={
    'today':HighlightedWord(
      onTap: ()=>print('Today'),
      textStyle: const TextStyle(
        color:Colors.blue,
        fontWeight:  FontWeight.bold
      ),
    ),
    'tomorrow':HighlightedWord(
      onTap: ()=>print('Tomorrow'),
      textStyle: const TextStyle(
          color:Colors.orange,
          fontWeight:  FontWeight.bold
      ),
    ),
    'bring':HighlightedWord(
      onTap: ()=>print('Bring'),
      textStyle: const TextStyle(
          color:Colors.pink,
          fontSize: 40.0,
          fontWeight:  FontWeight.bold
      ),
    ),
    'emergency':HighlightedWord(
      onTap: ()=>print('Emergency'),
      textStyle: const TextStyle(
          color:Colors.red,
          fontWeight:  FontWeight.bold
      ),
    ),
  };
  @override
  void initState(){
    super.initState();
    _speech=stt.SpeechToText();
  }
  Speechmodel speechmodel=new Speechmodel();
  bool speachcreated=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(
          icon:Icon(Icons.edit),
          onPressed: (){
            _gotoeditspeech(context,_text);
          },
        ),
          Builder(
            builder: createaddbutton,
          ),

          IconButton(
            icon:Icon(Icons.library_books),
            onPressed:(){
              gotospeechlistpage();
           }

          )
       ],
      ),
      body:Builder(
        builder: createmic,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(

        animate: false,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(microseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat:true,
        child: FloatingActionButton(
          onPressed: (){
              _listen();
          },
          child:Icon(_isListenning?Icons.mic:Icons.mic_none),
        ),
      ),

    );
  }
  Widget createaddbutton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          addspeech(_text, context);
          SnackBar sbforaddingtext=new SnackBar(content: Text("Text has been edited"),duration: Duration(milliseconds: 300),);
          Scaffold.of(context).showSnackBar(sbforaddingtext);
        }
    );
  }
  Widget createmic(BuildContext context){
    return SingleChildScrollView(
        reverse: true,

        child:Container(
            padding:const EdgeInsets.fromLTRB(30.0, 30.0,30.0, 150.0),
            child:TextHighlight(
              text: _text,
              words: _highlights,
              textStyle: const TextStyle(
                fontSize: 32.0,
                color:Colors.black,
                fontWeight: FontWeight.w400,
              ),


            )
        )
    );
  }
  void _gotoeditspeech(BuildContext context,String text) async{

    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => edit_speech(texttoedit:text,id:-1),
        ));

  }
  void gotospeechlistpage ()async{
    await Navigator.pushNamed(context, '/speechgridview');
  }

  void _listen() async{
      bool available=await _speech.initialize(
        onStatus: (val)=>print('onStatus: $val'),
        onError: (val)=>print('onError: $val'),
      );
        if(available) {
          setState(() => _isListenning = true);
          _speech.listen(
            onResult: (val) =>
                setState(() {
                  _text = val.recognizedWords;
                }),
            listenFor: Duration(minutes: 1),
          );
        }
        else{
          setState(() {
            _isListenning=false;
          });
          _speech.stop();
        }
    }
    void addspeech(String text,BuildContext context){
    speech speechadd=new speech(text);
    speechmodel.insertspeech(speechadd);

    }

  }


