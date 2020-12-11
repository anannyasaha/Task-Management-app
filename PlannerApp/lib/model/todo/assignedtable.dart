import "package:flutter/material.dart";
import "todomodel.dart";
import "todo.dart";
class assigneddatatable extends StatefulWidget {
  String title;
  assigneddatatable({Key key,this.title}):super(key:key);
  @override
  _assigneddatatableState createState() => _assigneddatatableState();
}

class _assigneddatatableState extends State<assigneddatatable> {
  List<todo> _todos=[];
  final _todomodel=new todomodel();
  void initState() {
    super.initState();

   getAssignedlist();
  }
  Future<void> getAssignedlist()async{
    List<todo> alltodoassigned=await _todomodel.getassignedtodos();
    setState(() {
      _todos=alltodoassigned;
    });

  }

  DataTable datatable(){
    return DataTable(
      columns: [
        DataColumn(
          label:Text("Description")
        ),
        DataColumn(
            label:Text("Task For")
        ),
        DataColumn(
            label:Text("Due date")
        )
      ],
      rows:
        _todos.map((todo)=>DataRow(
          cells:[ DataCell(
            Text(todo.description)
          ),
            DataCell(
              Text(todo.assignedto)
            ),
            DataCell(
              Text(todo.date)
            )
          ]
        )).toList()

    );
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title:Text(widget.title)
    ),
      body:datatable(),
    );
  }
}
