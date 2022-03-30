import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../main.dart';
import 'ScoreList.dart';
import 'about_logged_in..dart';
import 'contact_logged_in..dart';
import 'help_logged_in..dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:common_utilities/common_utilities.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'home_logged_in.dart';

class ScoreListDetails extends StatelessWidget {
  final String parent_username;
  final String token;
  final String student_id;
  final String student_name;
  final String operation;
  final String index;
  final String difficulty;
  final String id;

  ScoreListDetails(
      {Key? key,
      required this.parent_username,
      required this.token,
      required this.student_id,
      required this.student_name,
      required this.operation,
      required this.index,
      required this.difficulty,
      required this.id})
      : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          Menu(
            parent_username: parent_username,
            token: token,
          ),
          _ScoreListDetails(
            parent_username: parent_username,
            token: token,
            student_id: student_id,
            student_name: student_name,
            operation: operation,
            index: index,
            difficulty: difficulty,
            id: id,
          ),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  final String parent_username;
  final String token;
  Menu({Key? key, required this.parent_username, required this.token})
      : super(key: key);
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/TASK_BAR.png"),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _menuItem1(context),
                  _menuItem2(context),
                  _menuItem3(context),
                  _menuItem4(context),
                ],
              ),
              Row(
                children: [
                  _login_page(context),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _menuItem1(BuildContext context) {
    String parent_username = widget.parent_username;
    String token = widget.token;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AboutPage(parent_username: parent_username, token: token)),
          );
        },
        child: Text('Home'),
      ),
    );
  }

  Widget _menuItem2(BuildContext context) {
    String parent_username = widget.parent_username;
    String token = widget.token;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AboutPage(parent_username: parent_username, token: token)),
          );
        },
        child: Text('About Us'),
      ),
    );
  }

  Widget _menuItem3(BuildContext context) {
    String parent_username = widget.parent_username;
    String token = widget.token;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactPage(
                    parent_username: parent_username, token: token)),
          );
        },
        child: Text('Contact Us'),
      ),
    );
  }

  Widget _menuItem4(BuildContext context) {
    String parent_username = widget.parent_username;
    String token = widget.token;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HelpPage(parent_username: parent_username, token: token)),
          );
        },
        child: Text('Help'),
      ),
    );
  }

  Widget _login_page(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 75),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: Text('Sign Out'),
      ),
    );
  }
}

class _ScoreListDetails extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String student_name;
  final String operation;
  final String id;
  final String index;
  final String difficulty;
  final String token;
  _ScoreListDetails(
      {Key? key,
      required this.parent_username,
      required this.student_id,
      required this.student_name,
      required this.operation,
      required this.id,
      required this.index,
      required this.difficulty,
      required this.token})
      : super(key: key);
  @override
  ScoreListDetails1 createState() => ScoreListDetails1();
}

class ScoreListDetails1 extends State<_ScoreListDetails> {
  bool refresh = true;
  var items = [];
  var postresponse;
  List<ChartData> chartData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String index = widget.index;
    print("index is " + index);
    String id = widget.id;
    postresponse = await post(
        Uri.https(
            'uslsthesisapi.herokuapp.com', '/scorelist/' + widget.difficulty),
        body: {
          'operation': widget.operation,
          'student_id': widget.student_id,
        },
        headers: {
          "token": widget.token,
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
        });
    RefreshScreen();
  }

  RefreshScreen() async {
    if (postresponse.statusCode == 200) {
      items = json.decode(postresponse.body);
      var itemChart = json.decode(postresponse.body);
      setState(() {
        print(items);
        refresh = false;
        build(context);
        var reversedList = new List.from(items.reversed);
        for (Map<String, dynamic> i in reversedList) {
          chartData.add(ChartData.fromJson(i));
        }
        print(chartData);
      });
    } else {
      setState(() {
        print("testfail");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String student_id = widget.student_id;
    String parent_username = widget.parent_username;
    String operation = widget.operation;

    AdditionScoreList() async {
      String operation = 'addition';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScoreList(
                    parent_username: widget.parent_username,
                    student_id: widget.student_id,
                    student_name: widget.student_name,
                    operation: operation,
                    token: widget.token,
                  )));
    }

    SubtractionScoreList() async {
      String operation = 'subtraction';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScoreList(
                  parent_username: widget.parent_username,
                  student_id: widget.student_id,
                  student_name: widget.student_name,
                  operation: operation,
                  token: widget.token)));
    }

    MultiplicationScoreList() async {
      String operation = 'multiplication';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScoreList(
                  parent_username: widget.parent_username,
                  student_id: widget.student_id,
                  student_name: widget.student_name,
                  operation: operation,
                  token: widget.token)));
    }

    DivisionScoreList() async {
      String operation = 'division';
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScoreList(
                  parent_username: widget.parent_username,
                  student_id: widget.student_id,
                  student_name: widget.student_name,
                  operation: operation,
                  token: widget.token)));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(100),
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                child: Container(
                    width: 400,
                    height: 50,
                    child: Center(
                        child: Text(
                      "Addition",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                onPressed: () {
                  AdditionScoreList();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                        child: Text(
                      "Subtraction",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                onPressed: () {
                  SubtractionScoreList();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                        child: Text(
                      "Multiplication",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                onPressed: () {
                  MultiplicationScoreList();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                        child: Text(
                      "Division",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                onPressed: () {
                  DivisionScoreList();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                child: Container(
                    width: 300,
                    height: 50,
                    child: Center(
                        child: Text(
                      "Select Child",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                parent_username: widget.parent_username,
                                token: widget.token,
                              )));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 180, 19, 19),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              /*IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    ProfileViewerScreen();
                  }),
              SizedBox(height: 30),*/
            ],
          ),
        ),
        Container(
            child: Text("Student's Name : " +
                items[int.parse(widget.index)]["student_name"] +
                "\n" +
                "Test Taken in : " +
                items[int.parse(widget.index)]["date"].toString() +
                "\n" +
                "Time  : " +
                items[int.parse(widget.index)]["time"].toString() +
                "\n" +
                "Student's Score: " +
                items[int.parse(widget.index)]["rawscore"].toString() +
                "/" +
                items[0]["totalscore"].toString())),
        Container(
          height: 500,
          width: 700,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SfCartesianChart(
                title: ChartTitle(
                    text: "Scores of " +
                        widget.student_name +
                        ", " +
                        "Difficulty: " +
                        widget.difficulty),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(
                      text: 'Time',
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                ),
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.rawscore,
                      markerSettings: MarkerSettings(isVisible: true))
                ]),
          ]),
        )
      ],
    );
  }
}

/*Widget _buildcontactlist(BuildContext context) {
    return Scaffold(
        body: Column(
      verticalDirection: VerticalDirection.down,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
            child: Text("Student's Name : " +
                items[int.parse(widget.index)]["student_name"])),
        Container(
            child: Text("Test Taken in : " +
                items[int.parse(widget.index)]["date"].toString())),
        Container(
            child: Text("Time  : " +
                items[int.parse(widget.index)]["time"].toString())),
        Container(
            child: Text("Student's Score: " +
                items[int.parse(widget.index)]["rawscore"].toString() +
                "/" +
                items[0]["totalscore"].toString())),
        Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SfCartesianChart(
                title: ChartTitle(
                    text: "Scores of " +
                        widget.student_name +
                        ", " +
                        "Difficulty: " +
                        widget.difficulty),
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(
                      text: 'Time',
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                ),
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.rawscore,
                      markerSettings: MarkerSettings(isVisible: true))
                ]),
          ]),
        ),
      ],
    ));
  }*/

class ChartData {
  ChartData(this.date, this.rawscore);
  final String date;
  final int rawscore;
  factory ChartData.fromJson(Map<String, dynamic> parsedJson) {
    return ChartData(parsedJson["date"], parsedJson['rawscore']);
  }
}
