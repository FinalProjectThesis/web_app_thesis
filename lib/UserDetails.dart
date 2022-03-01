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
      home: UserDetails(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserDetails extends StatelessWidget {
  final String parent_username;
  final String token;
  final String student_id;
  UserDetails({Key key, this.parent_username, this.token, this.student_id})
      : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          Menu(),
          _UserDetails(
            parent_username: parent_username,
            token: token,
            student_id: student_id,
          ),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
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
              _menuItem(title: 'Home', isActive: true),
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

  Widget _menuItem({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.deepPurple : Colors.grey,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _menuItem2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
          );
        },
        child: Text('About Us'),
      ),
    );
  }

  Widget _menuItem3(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactPage()),
          );
        },
        child: Text('Contact Us'),
      ),
    );
  }

  Widget _menuItem4(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpPage()),
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

class _UserDetails extends StatefulWidget {
  final String parent_username;
  final String student_id;
  final String token;
  _UserDetails({Key key, this.parent_username, this.student_id, this.token})
      : super(key: key);
  @override
  UserDetails1 createState() => UserDetails1();
}

class UserDetails1 extends State<_UserDetails> {
  bool refresh = true;
  var items = [];
  var postresponse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String username = widget.parent_username;
    print(username);
    postresponse = await post(
        Uri.https('uslsthesisapi.herokuapp.com', '/userdetails'),
        body: {
          'username': username
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
        _buildcontactlist(context);
      });
    } else {
      setState(() {
        print("testfail");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Account Details"),
      ),
      //if Refresh = false then load circular progress indicator, else load _buildcontactlist widget
      body: refresh
          ? Center(child: CircularProgressIndicator())
          : _buildcontactlist(context),
    );
  }

  Widget _buildcontactlist(BuildContext context) {
    return Scaffold(
        body: Column(
      verticalDirection: VerticalDirection.down,
      children: [
        SizedBox(
          height: 30,
        ),
        Container(child: Text("Your Username : " + items[0]["username"])),
        Container(
            child:
                Text("Your First Name : " + items[0]["first_name"].toString())),
        Container(
            child:
                Text("Your Last Name : " + items[0]["last_name"].toString())),
      ],
    ));
  }
}
