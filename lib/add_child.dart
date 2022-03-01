import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'about_logged_in..dart';
import 'contact_logged_in..dart';
import 'help_logged_in..dart';
import 'home_logged_in.dart';
import 'main.dart';
import 'register_page.dart';

class ChildSetup extends StatelessWidget {
  final String parent_username;
  final String token;
  _ChildSetup createState() => _ChildSetup();
  ChildSetup({Key key, this.parent_username, this.token}) : super(key: key);
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
          AddChildSetup(
            parent_username: parent_username,
            token: token,
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
            children: [_menuItem(title: 'Add child', isActive: true)],
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                    HomePage(parent_username: parent_username, token: token)),
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
}

class AddChildSetup extends StatefulWidget {
  final String parent_username;
  final String token;

  AddChildSetup({Key key, this.parent_username, this.token}) : super(key: key);

  @override
  _ChildSetup createState() => _ChildSetup();
}

class _ChildSetup extends State<AddChildSetup> {
  final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  final _childnameController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _childageController = TextEditingController();

  void AddChild(BuildContext context) async {
    String studentname = _childnameController.text;
    String studentage = _childageController.text;
    String parent_username = widget.parent_username;
    String token = widget.token;

    var postresponse = await http
        .post(Uri.https('uslsthesisapi.herokuapp.com', '/childadd'), body: {
      "student_name": studentname,
      "student_age": studentage,
      "parent_username": parent_username
    }, headers: {
      'token': token,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
    });
    var response = json.decode(postresponse.body);
    if (response == "Success") {
      String parent_username = widget.parent_username;
      String token = widget.token;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            parent_username: parent_username,
            token: token,
          ),
        ),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: [
                Text('Successfully Added Student!'),
              ],
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.lightGreen,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text('There is an Error.'),
            ],
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register A Child',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Register a Child to see",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    " child's performance",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              /*Image.asset(
                'images/illustration-2.png',
                width: 300,
              ),*/
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
            child: _formLogin(context),
          ),
        )
      ],
    );
  }

  Widget _formLogin(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _childnameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: "Enter Child's Name",
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Child Name';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _childageController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: "Enter Child's Age",
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey[50]),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Child Age';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("Add Child"))),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  AddChild(context);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("RETURN"))),
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
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginWithButton({String image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[400]),
            ),
      child: Center(
          child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[400],
                    spreadRadius: 2,
                    blurRadius: 15,
                  )
                ],
              )
            : BoxDecoration(),
        child: Image.asset(
          '$image',
          width: 35,
        ),
      )),
    );
  }
}
