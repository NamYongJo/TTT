import 'package:calendar/pages/todo_list.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';

class Routes {
  Routes._();

  static const String main = '/';
  static const String todoPage = '/todoPage';

  static final routes = <String, WidgetBuilder>{
    main: (BuildContext context) => TableEventsExample(),
   // todoPage: (BuildContext context) => Todolist('2022-12-12')
  };
}