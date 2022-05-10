// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';

import '../login/login_main.dart';
import 'Calendar.dart';


class Todolist extends StatefulWidget {
  final DateTime _focusedDay;
  final int selectIndex;

  const Todolist(this._focusedDay,this.selectIndex);

  @override
  TodolistState createState() => TodolistState();
}

class TodolistState extends State<Todolist>{

  DateTime? _selectedDay;

  @override
  void initState() { //앱상태변경 이벤트 등록
    super.initState();

    _selectedDay = widget._focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
      });
    }
  }


  @override
  Widget build(BuildContext context){
    int selectIndex=widget.selectIndex;

    return Scaffold(
      appBar: AppBar(
        title:Text('To-do List'),
        backgroundColor: Colors.teal[300],
      ),
      body: Column(
      children: <Widget>[TableCalendar(
        firstDay:DateTime.utc(2022,1,1),
        lastDay: DateTime.utc(2022,12,31),
        calendarFormat: CalendarFormat.week,
        focusedDay: widget._focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        startingDayOfWeek: StartingDayOfWeek.sunday, //시작날짜
        onDaySelected: _onDaySelected,
        daysOfWeekHeight: 30,

        locale: 'ko-KR', //한국어로 변경
        headerStyle: HeaderStyle( //캘린더 헤더
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: true,
          rightChevronVisible: true,
        ),
        calendarStyle: CalendarStyle( //캘린더 스타일
          weekendTextStyle: TextStyle(color: Colors.blueGrey),
          todayDecoration: BoxDecoration(
              color: Colors.transparent
          ),
          todayTextStyle: TextStyle(
              color: Colors.black,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.teal.shade300, width: 1.5),
          ),
          selectedTextStyle: TextStyle(
              color: Colors.black
          ),
          outsideDaysVisible: false, //이전달의 날짜 보여주기
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context,day){
            switch(day.weekday){
              case 7:
                return Center(child: Text('일', style: TextStyle(color: Colors.red),));
            }
          }
        ),
        onFormatChanged: (format) {},
        onPageChanged: (focusedDay) {},
      ),
        const SizedBox(height: 10.0),
      Row(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            color: Colors.teal[300]),
            child: Text(DateFormat('MM.dd').format(_selectedDay!),
              style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
        ],
      ),
        Expanded(child: ListView()), //목록
        Container( //리스트 추가하기 버튼
          margin: EdgeInsets.all(20),
        child:Align(
          alignment: Alignment.bottomRight,
        child:FloatingActionButton(onPressed: (){},
          backgroundColor: Colors.teal[300],
          child: Icon(Icons.add),)))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: widget.selectIndex, //현재 인덱스 저장
        //인덱스 변경
        onTap: (index) =>{
          setState((){
            selectIndex=index; //클릭한 인덱스 번호를 현재 인덱스로 설정.
            switch (index){
              case 0:
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (BuildContext context) => TableEventsExample()), (route) => false);
                break;
              case 1:
                Navigator.push(context, PageTransition(child: Todolist(widget._focusedDay,widget.selectIndex), type: PageTransitionType.fade ));
                break;
              case 2:
                break;
              case 3:
                Navigator.push(context, PageTransition(child:Login(), type: PageTransitionType.fade ));
                break;
            }
          })
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.grey[600]), label: 'Home' ),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined, color: Colors.grey[600]), label: 'To-do' ),
          BottomNavigationBarItem(icon: Icon(Icons.tour_sharp, color: Colors.grey[600]), label: 'challenge' ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded, color: Colors.grey[600]), label: 'My Page' ),
        ],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
        selectedItemColor: Colors.teal[300],
      ),
    );
  }
}






