import 'package:PlannerApp/model/todo/todo.dart';
import 'package:PlannerApp/model/todo/todomodel.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class todolistpage extends StatefulWidget {
  String title;

  @override
  todolistpage({Key key,this.title}):super(key:key);
  _todolistpageState createState() => _todolistpageState();

}

class _todolistpageState extends State<todolistpage> {
  List<String> drawerItems=["All Tasks","Today","Tomorrow","This week","Assigned task"];
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
        ),IconButton(
          icon:Icon(Icons.add),
          onPressed:(){
            _gotoaddpage();


          }
        )]
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
                    Navigator.of(context).pop();
              },
             ),
              ],
        ),
      ) ,]
      )
    )


    );

  }
  List<todo> _todos=[];
  int _SelectedIndex=0;
  Future<void> _gotoaddpage() async{
    var todopage=await Navigator.pushNamed(context, '/addtodopage');

    gettodolist();

  }
  Future<void> gettodolist()async{
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
                  _SelectedIndex=index;

                });
              },
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide( //                   <--- left side
                          color: Colors.black,
                          width: 2.0,
                        ),
                  )),
                  child: ListTile(

                    title: Text(_todos[index].description),
                    subtitle: Text(_todos[index].time),
                    trailing: Text(_todos[index].date),
                  )
              )
          );
        }
    );
  }

}
