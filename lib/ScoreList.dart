import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../main.dart';
import 'ScoreListDetails.dart';
import 'about_logged_in..dart';
import 'contact_logged_in..dart';
import 'help_logged_in..dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:common_utilities/common_utilities.dart';
import 'home_logged_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'WebApp',
      home: ScoreList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScoreList extends StatelessWidget {
  final String parent_username;
  final String token;
  final String student_id;
  final String student_name;
  final String operation;

  ScoreList(
      {Key key,
      this.parent_username,
      this.token,
      this.student_id,
      this.student_name,
      this.operation})
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
          _ScoreList(
            parent_username: parent_username,
            token: token,
            student_id: student_id,
            student_name: student_name,
            operation: operation,
          ),
        ],
      ),
    );
  }
}

class Menu extends StatefulWidget {
  final String parent_username;
  final String token;
  Menu({Key key, this.parent_username, this.token}) : super(key: key);
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
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

class _ScoreList extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String student_name;
  final String operation;
  final String token;
  _ScoreList(
      {Key key,
      this.parent_username,
      this.student_id,
      this.student_name,
      this.operation,
      this.token})
      : super(key: key);
  @override
  ScoreList1 createState() => ScoreList1();
}

class ScoreList1 extends State<_ScoreList> {
  bool refresh = true;
  List _items = [];
  String dropdownvalue = 'All';
  var items = ['All', 'Easy', 'Medium', 'Hard'];
  var postresponse;

  @override
  void initState() {
    // TODO: implement initState
    postItems();
    super.initState();
  }

  postItems() async {
    String student_id = widget.student_id;
    String parent_username = widget.parent_username;
    String operation = widget.operation;
    if (dropdownvalue == 'All') {
      print(dropdownvalue);
      postresponse = await post(
          Uri.https('uslsthesisapi.herokuapp.com', '/scorelist'),
          body: {
            'operation': operation,
            'student_id': student_id
          },
          headers: {
            "token": widget.token,
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
          });
      print("test");
      if (postresponse.statusCode == 200) {
        var items = json.decode(postresponse.body);
        print("testsuccess");
        print(items);
        setState(() {
          refresh = false;
          build(context);
          _items = items;
        });
      } else {
        setState(() {
          _items = [];
          print("testfail");
        });
      }
    } else if (dropdownvalue == 'Easy' ||
        (dropdownvalue?.contains("Medium") ?? false) ||
        (dropdownvalue?.contains("Hard") ?? false)) {
      postresponse = await post(
          Uri.https(
              'uslsthesisapi.herokuapp.com', '/scorelist/' + dropdownvalue),
          body: {
            'operation': operation,
            'student_id': student_id
          },
          headers: {
            'token': widget.token,
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
          });
      print("test");
      if (postresponse.statusCode == 200) {
        var items = json.decode(postresponse.body);
        print("connectionsusccess");
        print(items);
        setState(() {
          refresh = false;
          print("test2");
          build(context);
          _items = items;
        });
      } else {
        setState(() {
          _items = [];
          print("connectionfailed");
        });
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
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
        //add here list of scores
        Container(
            height: 500,
            width: 1000,
            padding: const EdgeInsets.all(25),
            child: new Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment(0.90, -0.80),
                child: DropdownButton(
                  value: dropdownvalue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String chosenValue) {
                    setState(() {
                      dropdownvalue = chosenValue;
                      postItems();
                    });
                  },
                ),
              ),
              _items.length > 0
                  ? Expanded(
                      child: SizedBox(
                      height: 500,
                      width: 1000,
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              dense: true,
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(_items[index]["rawscore"].toString() +
                                        '/' +
                                        _items[index]["totalscore"].toString())
                                  ]),
                              title: Text("Difficulty: " +
                                  StringUtils.capitalize(_items[index]
                                          [('difficulty')]
                                      .toString()
                                      .toUpperCase())),
                              subtitle: Text(
                                  "Date: " + _items[index]["date"].toString()),
                              onTap: () {
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScoreListDetails(
                                                parent_username:
                                                    widget.parent_username,
                                                student_id: _items[index]
                                                        ["student_id"]
                                                    .toString(),
                                                student_name: _items[index]
                                                        ["student_name"]
                                                    .toString(),
                                                operation: _items[index]
                                                    ["operation"],
                                                id: _items[index]["id"]
                                                    .toString(),
                                                index: index.toString(),
                                                difficulty: _items[index]
                                                    ["difficulty"],
                                                token: widget.token,
                                              )));
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ))
                  : Container(
                      width: double.infinity,
                      height: 300,
                      alignment: Alignment.center,
                      child: Container(
                          width: 200,
                          height: 200,
                          child: Text(
                            "Empty!, Please Take a Test with this difficulty and operation to add into this list!",
                            textAlign: TextAlign.center,
                          )),
                    )
            ]))
      ],
    );
  }
}
