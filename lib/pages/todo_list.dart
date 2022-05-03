// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Todolist extends StatefulWidget {
  final DateTime _focusedDay;


  const Todolist(this._focusedDay);

  @override
  TodolistState createState() => TodolistState();
}

class TodolistState extends State<Todolist>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text('To-do List'),
        backgroundColor: Colors.teal[300],
      ),
      body: Text(DateFormat('MM-dd').format(widget._focusedDay),
      style: TextStyle(fontSize: 20,),),
    );
  }
}





