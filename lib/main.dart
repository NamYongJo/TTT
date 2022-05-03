import 'package:TTT/pages/todo_list.dart';
import 'package:TTT/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../utils.dart';


void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: TableEventsExample(),
    );
  }
}


class TableEventsExample extends StatefulWidget {
  //statefulWidget => http 호출이나 사용자와 상호작용으로 받은 데이터 기반으로 동적 변경 가능.
  const TableEventsExample({Key? key}) : super(key: key);

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() { //앱상태변경 이벤트 등록
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() { //앱 상태변경 이벤트 해제
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) { //값이 있으면 마커표시
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  //마커 표시 커스텀
  Widget _buildEventsMarkerNum(List events){
    return buildCalendarDayMarker(
      text: '${events.length}',
    );
  }

  AnimatedContainer buildCalendarDayMarker({
  required String text,
}) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape:  BoxShape.rectangle,
          color: Colors.teal[300],
        ),
      width: 47,
      height: 12,
        child:Center(
          child: Text(
            text,
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 10.0
          ),
        ),),
    );
  }

  //appbar에 같히지 않고 내가 만든 위젯에 자유롭게 구현가능(endDrawer때문)
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // debugShowCheckedModeBanner: false, //디버그 배너 없애기
     // routes: Routes.routes, //페이지 이동 관리
     // initialRoute: '/',
      title: 'calendar',
      theme: ThemeData( //버튼 누를때 효과 없애기 (앱 전체에 적용)
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/back3.png'),
          ),
        ),
        child: Scaffold(
          key: _scaffoldkey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal, //오버플로우 방지
              child:Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logoCal.png',width: 160,height: 100,)
              ],
            ),),
            toolbarHeight: 50,
            actions: <Widget>[
              IconButton(onPressed:(){
                _scaffoldkey.currentState?.openEndDrawer();
              }, //메뉴 클릭
                  icon: Icon(Icons.menu, color: Colors.black,))
             ],
             backgroundColor: Colors.transparent,
             elevation: 0.0,
          ),
          //메뉴 클릭했을때
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      backgroundColor: Colors.white,
                    ),
                    accountName: Text(' User1',style: TextStyle(fontSize: 20,),),
                    accountEmail: Text(' user1@gmail.com'),
                    onDetailsPressed: (){ //계정 관련 페이지로 이동(정보수정, 팔로우
                      print('arrow clicked');
                    },
                  decoration: BoxDecoration(
                    color: Colors.teal[400],
                    borderRadius: BorderRadius.only(
                     // bottomLeft: Radius.circular(40.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.grey[850],
                  ),
                  title: Text('setting'),
                  onTap: (){
                    print('setting clicked');
                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[ //클릭이벤트
              TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay, //이벤트
                startingDayOfWeek: StartingDayOfWeek.sunday, //시작날짜

                locale: 'ko-KR', //한국어로 변경
                daysOfWeekHeight: 30, //간격조절
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
                      color: Colors.teal.shade300,
                      fontWeight: FontWeight.bold
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
                  //마커
                  markerBuilder: (context, day, events) {
                    return events.isNotEmpty? _buildEventsMarkerNum(events) : Container();
                  },

                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 27.0),
              Row( //목록 타이틀
                children: [
                  TextButton.icon(onPressed: (){ //투두리스트 페이지로 이동
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Todolist(_focusedDay))); //데이터 넘기기
                  }, //클릭하면 투두리스트 페이지로
                      icon: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 19,),
                      //날짜 포맷 바꾸기.
                      label: Text(DateFormat('MM-dd').format(_focusedDay), style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),),
                    style: TextButton.styleFrom(
                      primary: Colors.teal,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) { //이벤트 내용 불러오기
                    return ListView.builder(
                      itemCount: value.length, //리스트 개수
                      itemBuilder: (context, index) { //리스트 반복문 항목
                        return Container(
                          height: 35,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(color: Colors.blueGrey, width: 4.0,),),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x29292B17),
                                offset: Offset(1.0,1.0),
                                blurRadius: 2.0,
                                spreadRadius: 2.0,
                              )
                            ]
                          ),
                          child: ListTile(
                            //leading: Icon(Icons.check_box),
                            title: SizedBox(
                              child:Text('${value[index]}',
                              style: TextStyle(fontSize: 14,
                              ),
                            ),
                            height: 50,)
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (index) =>{},
            items: [
              BottomNavigationBarItem(icon:Icon(Icons.home), label:'Home' ),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark),label: 'To-do List'),
              BottomNavigationBarItem(icon: Icon(Icons.golf_course),label: 'Challenge'),
            ],
            currentIndex: 0,
            
          ),
        ),
      ),
    );
  }
}
