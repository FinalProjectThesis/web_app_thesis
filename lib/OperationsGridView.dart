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
import 'UserDetails.dart';
import 'about_logged_in..dart';
import 'contact_logged_in..dart';
import 'help_logged_in..dart';
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
      home: OperationsGridView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OperationsGridView extends StatelessWidget {
  final String parent_username;
  final String token;
  final String student_id;
  final String student_name;
  final String student_age;
  OperationsGridView(
      {Key key,
      this.parent_username,
      this.token,
      this.student_id,
      this.student_name,
      this.student_age})
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
          _OperationsGridView(
            parent_username: parent_username,
            token: token,
            student_id: student_id,
            student_name: student_name,
            student_age: student_age,
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

class _OperationsGridView extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String student_name;
  final String student_age;
  final String token;
  _OperationsGridView(
      {Key key,
      this.parent_username,
      this.student_id,
      this.student_name,
      this.student_age,
      this.token})
      : super(key: key);
  @override
  OperationsGridView1 createState() => OperationsGridView1();
}

class OperationsGridView1 extends State<_OperationsGridView> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget space(BuildContext) {
    Container(
      height: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Please Select an \nOperation to View',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
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

        /* Image.asset(
          'images/illustration-1.png',
          width: 300,
        ),*/
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 6),
          child: Container(
            width: 320,
            //child: _formLogin(context),
          ),
        )
      ],
    );
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

  ProfileViewerScreen() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserDetails(
                parent_username: widget.parent_username,
                student_id: widget.student_id,
                token: widget.token)));
  }
}
