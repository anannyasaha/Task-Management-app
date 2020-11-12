import 'package:PlannerApp/model/todo/todomodel.dart';
import 'package:flutter/material.dart';
import 'todo.dart';
class addtodo extends StatefulWidget {
 final String title;
  addtodo({Key key,this.title}):super(key:key);
  @override
  _addtodoState createState() => _addtodoState();
}

class _addtodoState extends State<addtodo> {
  String description="";
  String priority;
  String dateoftodo="Enter date";
  String timeoftodo="Enter time";
  String assignedto;

  final _todomodel=new todomodel();
  DateTime _eventDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String emailaddress="";
  String message="";
  TextEditingController _controller2=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Text("Add todo"),
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
    TextEditingController _controller3=TextEditingController();
    TextEditingController _controller4=TextEditingController();

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
                            firstDate: DateTime.now(),
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
                            timeoftodo=_toTimeString(_eventDate);

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

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Assignedto",),
                  controller: _controller2,
                  onTap: ()async{
                    String name=await _customDialog(context);
                    setState(() {
                      _controller2.text=name;
                    });

                  },
                  onSaved: (String value) {
                    assignedto = value;
                    print("Saving value $value");
                  },),
                RaisedButton(
                  onPressed:() async{

                    _formKey.currentState.save();

                    todo newtodo=todo(description,priority,dateoftodo,timeoftodo,assignedto);
                    _addtodo(newtodo);
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
  Future<void> _addtodo(todo Todo) async {

    int lastinsertedid = await _todomodel.inserttodo(Todo);
    print(lastinsertedid);

  }


 Future<String> _customDialog(BuildContext context) {
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
                TextField(
                    decoration:InputDecoration(labelText: "message",hintText: "This Task is essential for today's dinner"),
                    onChanged:(value){
                      message=value;
                    }
                ),
              ],
            ),

            actions:[RaisedButton(
              child:Text("Done"),
              onPressed: (){
                print('$emailaddress');
                Navigator.of(context).pop(name);
                _controller2.text=name;
              },
            )]



          ),
        );
        }
    );}
  String _toTimeString(DateTime date) {
    return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }
  String _twoDigits(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }
  String toOrdinal(number) {
    if ((number >= 10) && (number <= 19)) {
      return number.toString() + 'th';
    } else if ((number % 10) == 1) {
      return number.toString() + 'st';
    } else if ((number % 10) == 2) {
      return number.toString() + 'nd';
    } else if ((number % 10) == 3) {
      return number.toString() + 'rd';
    } else {
      return number.toString() + 'th';
    }
  }

  String toMonthName(monthNum) {
    switch (monthNum) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Error';
    }
  }

  String toDateString(DateTime date) {
    return '${toMonthName(date.month)} ${toOrdinal(date.day)}';
  }
}
