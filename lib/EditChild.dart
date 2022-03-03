import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../main.dart';
import 'about_logged_in..dart';
import 'contact_logged_in..dart';
import 'help_logged_in..dart';
import 'home_logged_in.dart';

class EditChild extends StatelessWidget {
  final String parent_username;
  final String token;
  final String student_id;
  final String student_age;
  final String student_name;
  EditChild(
      {Key? key,
      required this.parent_username,
      required this.token,
      required this.student_id,
      required this.student_age,
      required this.student_name})
      : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          Menu(parent_username: parent_username, token: token),
          _EditChild(
            parent_username: parent_username,
            student_age: student_age,
            student_id: student_id,
            student_name: student_name,
            token: token,
            key: null,
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

class _EditChild extends StatefulWidget {
  final String parent_username;
  final String student_name;
  final String student_age;
  final String student_id;
  final String token;
  _EditChild({
    required Key? key,
    required this.student_id,
    required this.parent_username,
    required this.student_name,
    required this.student_age,
    required this.token,
  }) : super(key: key);
  @override
  EditChild1 createState() => EditChild1();
}

class EditChild1 extends State<_EditChild> {
  final _formKey = GlobalKey<FormState>();
  //late TextEditingController _childnameController, _childageController;
  // ignore: non_constant_identifier_names
  late TextEditingController _childnameController;
  late TextEditingController _childageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _childnameController =
        TextEditingController(text: widget.student_name);
    // ignore: non_constant_identifier_names
    final _childageController = TextEditingController(text: widget.student_age);
  }

  EditChild(BuildContext context) async {
    String studentname = _childnameController.text;
    String studentage = _childageController.text;
    if (studentname == widget.student_name) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Container(
          height: 15,
          child: Row(
            children: [
              Text("Please Enter a different name"),
            ],
          ),
        ),
      ));
    } else {
      var postresponse = await put(
          Uri.https('uslsthesisapi.herokuapp.com',
              '/childedit/update/' + widget.student_id),
          body: {
            "student_name": studentname,
            "student_age": studentage,
          },
          headers: {
            "token": widget.token,
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
          });
      if (postresponse.statusCode == 200) {
        print("testsuccess");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(
              parent_username: widget.parent_username,
              token: widget.token,
            ),
          ),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: [
                Text('Student ' + widget.student_name + ' Modified'),
              ],
            ),
          ),
        ));
      } else {
        print(postresponse.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: [
                Text("Error in Modifying child"),
              ],
            ),
          ),
        ));
      }
    }
  }

  showConfirmDeleteDialog(BuildContext context) {
    // set up the buttons
    Widget CancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget ConfirmButton = TextButton(
        child: Text("Continue"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          delete(
            Uri.https('uslsthesisapi.herokuapp.com',
                '/childedit/delete/' + widget.student_id),
            headers: {
              "token": widget.token,
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
            },
          );
          Timer(Duration(seconds: 2), () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.deepOrange,
              content: Container(
                height: 15,
                child: Row(
                  children: [
                    Text('Student ' + widget.student_name + ' Deleted'),
                  ],
                ),
              ),
            ));
          });
        });

    AlertDialog alert = AlertDialog(
      title: Text("Delete this Child"),
      content: Text("Are you sure you want to delete this Child?"),
      actions: [
        CancelButton,
        ConfirmButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                'Update A Child',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Update or Delete a Child",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
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
            child: buildRegisterScreen(context),
          ),
        )
      ],
    );
  }

  Widget buildRegisterScreen(BuildContext context) {
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
              hintText: "Edit Child's Name",
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 236, 238, 241)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 236, 238, 241)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Child Name to Update';
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
              hintText: "Edit Child's Age",
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: TextStyle(fontSize: 12),
              contentPadding: EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 236, 239, 241)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 236, 240, 241)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Child Age to Update';
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
                  child: Center(child: Text("Update Child"))),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  EditChild(context);
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
                  child: Center(child: Text("Delete Child"))),
              onPressed: () {
                showConfirmDeleteDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 252, 17, 17),
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
}
