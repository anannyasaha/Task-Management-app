import 'package:PlannerApp/model/todo/todo.dart';
import 'package:PlannerApp/model/todo/todomodel.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD:PlannerApp/lib/utilities.dart

import 'main.dart';
import 'model/todo/edittodopage.dart';
=======
>>>>>>> 54b6fe68cf5804ec07038317e3d155e68ab73039:PlannerApp/lib/helper/utilities.dart

class todolistpage extends StatefulWidget {
  String title;

  @override
  todolistpage({Key key,this.title}):super(key:key);
  _todolistpageState createState() => _todolistpageState();

}

class _todolistpageState extends State<todolistpage> {
<<<<<<< HEAD:PlannerApp/lib/utilities.dart

  List<String> drawerItems=["All Tasks","Today","Tomorrow","Assigned task","Old tasks"];
  List<String> items=["Assign task to some one","Add task for you"];
  int _SelectedIndex=0;
=======
  List<String> drawerItems=["All Tasks","Today","Tomorrow","This week","Assigned task"];
>>>>>>> 54b6fe68cf5804ec07038317e3d155e68ab73039:PlannerApp/lib/helper/utilities.dart
  final _todomodel=new todomodel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title:Text(widget.title) ,
        actions:[IconButton(
          icon:Icon(Icons.edit),
          onPressed: (){
           // _gotoeditpage();
          },
        ),

            PopupMenuButton<String>(
              icon: const Icon(Icons.add),
              onSelected: (String value) {
              if(value=="Assign task to some one") _gotoassignedpage();
              if(value=="Add task for you")_gotoaddpage();
              },
              itemBuilder: (BuildContext context) {
                return items
                    .map<PopupMenuItem<String>>((String value) {
                  return new PopupMenuItem(
                      child: new Text(value), value: value);
                }).toList();
              },
            ),

          IconButton(
            icon:Icon(Icons.edit),
            onPressed: (){
               _gotoeditpage(context,_SelectedIndex);
               gettodolist();
            },
          ),
        ]
    ),
      body:_createlistview(context),
      drawer: Drawer(
        child: Column(

          children: [
            Expanded(
              flex:1,
              child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color:Colors.white,
                      image: DecorationImage(
                          image: AssetImage("assets/Stay-Organized.jpg"),
                          fit: BoxFit.contain
                      )
                  ),
                ),
              ),
            ),
            Expanded(
            flex: 2,
              child: ListView(children: [
                ListTile(
                 title: Text(drawerItems[0]),
                 trailing: IconButton(
                   icon:Icon(Icons.add),

                 ),
               onTap: () {
                 Navigator.of(context).pop();
               },
               ),
               ListTile(
                title: Text(drawerItems[1]),
                 trailing: Icon(Icons.add),
                onTap: () {
               Navigator.of(context).pop();
                },
              ),
               ListTile(
                 title: Text(drawerItems[2]),
                trailing: Icon(Icons.add),
              onTap: () {
               Navigator.of(context).pop();
                },
              ),
                ListTile(
                  title: Text(drawerItems[3]),
                  trailing: Icon(Icons.add),
              onTap: () {
<<<<<<< HEAD:PlannerApp/lib/utilities.dart
                    _gotoassignedlistpage();
                    gettodolist();
=======
                    Navigator.of(context).pop();
>>>>>>> 54b6fe68cf5804ec07038317e3d155e68ab73039:PlannerApp/lib/helper/utilities.dart
              },
             ),
              ],
        ),
      ) ,]
      )
    ),
        floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon:Icon(Icons.delete_forever),
          tooltip: "If the task's duedate is 4 days old then you will find them in \"Old tasks\".If you use this Delete option it will delete for ever",
          onPressed: ()async{
            await _todomodel.deletetodo(_SelectedIndex);
            gettodolist();
          },
        ),
    ),


    );

  }
  void _gotoeditpage(BuildContext context,int id) async{

    var gradepage=await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => edittodo(title:"Edit todo",id: id),
        ));
    setState(() {
      _todos=gradepage;
    });
    gettodolist();
  }
  Future<void> _gotoassignedpage() async{
    var todopage=await Navigator.pushNamed(context, '/assignedtodopage');

  }
  List<todo> _todos=[];
<<<<<<< HEAD:PlannerApp/lib/utilities.dart
  Future<void> _gotoassignedlistpage() async{
    var todopage=await Navigator.pushNamed(context, '/assignedtable');
    gettodolist();

  }

=======
  int _SelectedIndex=0;
>>>>>>> 54b6fe68cf5804ec07038317e3d155e68ab73039:PlannerApp/lib/helper/utilities.dart
  Future<void> _gotoaddpage() async{
    var todopage=await Navigator.pushNamed(context, '/addtodopage');

    gettodolist();

  }
<<<<<<< HEAD:PlannerApp/lib/utilities.dart
  Future<void> getOldtodos()async{
    List<todo> alltodos=await _todomodel.getoldtodos();
    setState(() {
      _todos=alltodos;
    });

  }

=======
>>>>>>> 54b6fe68cf5804ec07038317e3d155e68ab73039:PlannerApp/lib/helper/utilities.dart
  Future<void> gettodolist()async{
    List<todo> oldtodos=await _todomodel.deleteoldtodos();
    List<todo> alltodos=await _todomodel.getAlltodos();
    setState(() {
      _todos=alltodos;
    });

  }
  @override
  void initState() {
    super.initState();

    gettodolist();
  }
  List<bool> selected=List.generate(100, (index) => false);
  Widget _createlistview(BuildContext context){

    return ListView.builder(

        itemCount:_todos==null ? 0 : _todos.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: (){
                setState(() {
                  selected=List.generate(100, (index) => false);
                  selected[index]=!selected[index];
                  _SelectedIndex=_todos[index].id;
                  print("selected index $_SelectedIndex");
                  print(_todos[index]);

                });
              },
              child: Container(

                  decoration: BoxDecoration(
                    color: selected[index]==true? Colors.blue :Colors.white,
                      border: Border(
                        left: BorderSide( //                   <--- left side
                          color: Colors.black,
                          width: 2.0,
                        ),
                  ),),

                  child: ListTile(
                    title: Text(_todos[index].description),
                    subtitle: Text(_todos[index].time),
                    trailing: Text(_todos[index].date),
<<<<<<< HEAD:PlannerApp/lib/utilities.dart
                    leading: CircleAvatar(

                        child: Text(_todos[index].time)),

=======
>>>>>>> 54b6fe68cf5804ec07038317e3d155e68ab73039:PlannerApp/lib/helper/utilities.dart
                  )
              )
          );
        }
    );
  }

}
