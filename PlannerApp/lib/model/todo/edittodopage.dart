import 'package:flutter/material.dart';
import 'package:PlannerApp/model/todo/todomodel.dart';
import 'addtodopage.dart';
import 'todo.dart';



import 'package:flutter_email_sender/flutter_email_sender.dart';

class edittodo extends StatefulWidget {
  final String title;
  final int id;
  edittodo({Key key,this.title,this.id}):super(key:key);
  @override
  _edittodoState createState() => _edittodoState();
}

class _edittodoState extends State<edittodo> {
  String description="";
  String priority;
  String dateoftodo="Enter date";
  String timeoftodo="Enter time";
  String assignedto="";

  final _todomodel=new todomodel();
  DateTime _eventDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String emailaddress="";
  String message="";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text(widget.title),
        leading: IconButton(
            icon:Icon(Icons.arrow_back),
            onPressed:(){
              Navigator.of(context).pop(null);
            }),
      ),
      body:Builder(
        builder: createform,
      ),

    );
  }
  Widget createform(BuildContext context){
    TextEditingController _controller=TextEditingController();


    List<String> items=["High","Moderate","Low"];
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
                    FlatButton(
                      child:Text(timeoftodo),
                      onPressed:()async {
                        TimeOfDay time=await showTimePicker(
                            context: context,
                            initialTime:TimeOfDay(hour:rightNow.hour,minute:rightNow.minute))
                            .then((value) {
                          setState(() {
                            // overwrite hours/minutes with new values, keep date the same
                            _eventDate = DateTime(
                              _eventDate.year,
                              _eventDate.month,
                              _eventDate.day,
                              value.hour,
                              value.minute,
                            );
                            timeoftodo=toTimeString(_eventDate);

                          });
                        });
                      },)
                  ],
                ),

                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "priority",
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        _controller.text = value;
                        priority=value;
                      },
                      itemBuilder: (BuildContext context) {
                        return items
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ),
                ),


                RaisedButton(
                  onPressed:() async{

                    _formKey.currentState.save();

                    todo newtodo=todo(description,priority,dateoftodo,timeoftodo,assignedto);
                    newtodo.id=widget.id;
                    editTodo(newtodo);

                    SnackBar sbforaddingtodo=new SnackBar(content: Text("Todo has been edited"));
                    Scaffold.of(context).showSnackBar(sbforaddingtodo);
                    //List todos= await _todomodel.getAlltodos();
                    //Navigator.of(context).pop(todos);


                  },

                  child: Icon(Icons.save),

                )

              ]
          )
      ),
    );
  }


  Future<void> editTodo(todo Todo) async {
    await _todomodel.updatetodo(Todo);
  }

}
