import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Speechmodel.dart';
import 'speech.dart';

class speechlist extends StatefulWidget {
  @override
  _speechlistState createState() => _speechlistState();
}

class _speechlistState extends State<speechlist> {
  Speechmodel speechmodel=new Speechmodel();
  TextEditingController controller=new TextEditingController();
  List<dynamic> Speechlist = [];
  void initState() {
    super.initState();
    getspeechlist();
  }
  Future<void> getspeechlist()async{
    List<speech> allspeech=await speechmodel.getAllspeech();
    setState(() {
      Speechlist=allspeech;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Speech list'),
        actions: [
          IconButton(icon: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pop();

            },),
        ],
      ),
      body:Container(
        padding: EdgeInsets.all(10),
        child: Speechlist == null? Container()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:3 ,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0
                ),

                itemCount: Speechlist.length,
                itemBuilder: (BuildContext context,int index){
                return GestureDetector(
                  onTap: (){
                    setState(() {
                      controller.text=Speechlist[index].Description;
                    });
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return new AlertDialog(
                           content: SingleChildScrollView(
                             child: Column(
                               children: [

                                   Container(
                                    color:whatColor(index),
                                      child:TextField(
                                        controller:controller,
                                          maxLines: null,
                                          style:TextStyle(fontSize:30))
                               ),

                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     RaisedButton(
                                       child:Text("Save"),
                                       onPressed: (){
                                         editspeech(controller.text,Speechlist[index].id );
                                         getspeechlist();
                                         Navigator.of(context).pop();
                                       },
                                     ),
                                     RaisedButton(
                                       child:Text("Delete"),
                                       onPressed: (){
                                        deletespeech(Speechlist[index].id);
                                         getspeechlist();
                                         Navigator.of(context).pop();
                                       },
                                     )
                                   ],
                                 )
                               ],
                             ),
                           ),
                      );
                      }
                    );

                  },
                  child: Container(
                    padding:const EdgeInsets.all(10),
                    child: Text(

                        Speechlist[index].Description,
                        style:TextStyle(fontSize:20)),
                    color:whatColor(index),


                  ),
                );
               },
            ),
      )
    );
  }
  Color whatColor(int i){
    if((i+1)%3==1){
      return Colors.teal[100];
    }
    else if((i+1)%3==2){
      return Colors.teal[200];
    }
    else return Colors.teal[300];
  }
  void editspeech(String text,int id){

    speech speechupdate=new speech(text);
    speechupdate.id=id;
    speechmodel.updatespeech(speechupdate);
  }
  deletespeech(int id){
    speechmodel.deletespeech(id);
  }
}
