import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:PlannerApp/main.dart';
import 'addtodopage.dart';
import 'todo.dart';
import 'todomodel.dart';
import 'addtodopage.dart';
class CallsAndMessagesService {
  void sendEmail(String email) => launch("mailto:$email");

}
class assignedadd extends StatefulWidget {
  @override
  _assignedaddState createState() => _assignedaddState();
}

class _assignedaddState extends State<assignedadd> {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  String description="";
  final _todomodel=new todomodel();
  String dateoftodo="Enter date";
  String emailaddress="";
  String assignedto;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller2=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:Text("Assign Task"),

      ),
      body:Builder(
        builder: createform,
      ),
    );
  }
  SingleChildScrollView createform(BuildContext context){
    TextEditingController _controller=TextEditingController();


    //List<String> items=["High","Moderate","Low"];
    // String dateoftodo=toDateString(DateTime.now());
    // String timeoftodo=_toTimeString(DateTime.now());
    DateTime rightNow = DateTime.now();
    return SingleChildScrollView(
      child: new Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),

                    validator: (String value) {
                      print("Validating");
                      if (value.isEmpty) {
                        return "Description required";
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      description = value;
                    }),
                Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      child:Text(dateoftodo),

                      onPressed:()async {
                        DateTime date=await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2021));
                        setState(() {
                          dateoftodo=toDateString(date);

                        });
                      },),

                  ],
                ),



                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Assignedto",),
                  controller: _controller2,
                  onTap: ()async{
                    await _customDialog(context);


                  },
                  onSaved: (String value) {
                    assignedto = value;
                    print("Saving value $value");
                  },),
                RaisedButton(
                  onPressed:() async{

                    _formKey.currentState.save();

                    todo newtodo=todo(description,"",dateoftodo,"",assignedto);
                    addtodo(newtodo);
                    SnackBar sbforaddingtodo=new SnackBar(content: Text("Todo has been added"));
                    Scaffold.of(context).showSnackBar(sbforaddingtodo);
                    //List todos= await _todomodel.getAlltodos();
                    //Navigator.of(context).pop(todos);
                    print(newtodo);

                  },

                  child: Icon(Icons.save),

                )

              ]
          )
      ),
    );
  }
  Future<void> addtodo(todo Todo) async {

    int lastinsertedid = await _todomodel.inserttodo(Todo);
    print(lastinsertedid);

  }
  Future<void> _customDialog(BuildContext context) {
    String name;
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder:(BuildContext context){
          return SingleChildScrollView(
            child: AlertDialog(
                title:Text("enter his email"),
                content: Column(
                  children: [
                    TextField(
                        decoration:InputDecoration(labelText: "Name",hintText: "Mark Green"),
                        onChanged:(value){
                          assignedto=value;
                          name=value;
                        }
                    ),

                    TextField(
                        decoration:InputDecoration(labelText: "email",hintText: "example@gmail.com"),
                        onChanged:(value){
                          emailaddress=value;
                        }
                    ),

                  ],
                ),

                actions:[RaisedButton(
                  child:Text("Done"),
                  onPressed: () {
                    _service.sendEmail(emailaddress);
                    Navigator.of(context).pop(name);
                    _controller2.text=name;
                  },
                )]



            ),
          );
        }
    );}

}
