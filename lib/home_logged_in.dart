import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:login/add_child.dart';
import '../main.dart';
import 'package:login/add_child.dart';
import 'EditChild.dart';
import 'OperationsGridView.dart';
import 'about_logged_in..dart';
import 'contact_logged_in..dart';
import 'help_logged_in..dart';

class HomePage extends StatelessWidget {
  final String parent_username;
  final String token;
  HomePage({Key? key, required this.parent_username, required this.token})
      : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          Menu(parent_username: parent_username, token: token),
          ChildrenList(
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
    String parent_username = widget.parent_username;
    String token = widget.token;
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

class ChildrenList extends StatefulWidget {
  final String parent_username;
  final String token;
  ChildrenList({Key? key, required this.parent_username, required this.token})
      : super(key: key);
  @override
  _ChildrenList createState() => _ChildrenList();
}

class _ChildrenList extends State<ChildrenList> {
  bool refresh = true;
  List _items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    String parent_username = widget.parent_username;
    var postresponse = await post(
        Uri.https('uslsthesisapi.herokuapp.com', '/childlist'),
        body: {
          'parent_username': parent_username
        },
        headers: {
          'token': widget.token,
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, GET, PUT, DELETE",
        });
    var response = json.decode(postresponse.body);
    print("test");
    print(response);
    if (postresponse.statusCode == 200) {
      var items = json.decode(postresponse.body);
      print("testsuccess");
      print(items);
      setState(() {
        build(context);
        _items = items;
      });
    } else {
      setState(() {
        _items = [];
        print("testfail");
      });
    }
  }

  //test to get data
  /*@override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          context;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => fetchUser()),
          );
        },
        child: Text('get data'),
      ),
    );
  }*/

  Widget build(BuildContext context) {
    String parent_username = widget.parent_username;
    String token = widget.token;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 500,
        width: 1000,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/chalkboard.png"),
                fit: BoxFit.cover)),
        padding: const EdgeInsets.all(25),
        child: new Column(mainAxisSize: MainAxisSize.min, children: [
          _items.length > 0
              ? new Expanded(
                  child: SizedBox(
                  height: 500,
                  width: 1000,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.person),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditChild(
                                                  parent_username:
                                                      widget.parent_username,
                                                  student_id: _items[index]
                                                          ["id"]
                                                      .toString(),
                                                  student_name: _items[index]
                                                          ["student_name"]
                                                      .toString(),
                                                  student_age: _items[index]
                                                          ["student_age"]
                                                      .toString(),
                                                  token: widget.token))).then(
                                          (value) => setState(() {
                                                fetchUser();
                                              }));
                                    }),
                              ],
                            ),
                            leading: CircleAvatar(
                                backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                child: Text(_items[index]['student_name']
                                    .substring(0, 1)
                                    .toUpperCase())),
                            title: Text(_items[index]['student_name']),
                            subtitle: Text("Student Age: " +
                                _items[index]["student_age"].toString()),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OperationsGridView(
                                            parent_username:
                                                widget.parent_username,
                                            student_id:
                                                _items[index]["id"].toString(),
                                            student_name: _items[index]
                                                    ["student_name"]
                                                .toString(),
                                            student_age: _items[index]
                                                    ["student_age"]
                                                .toString(),
                                            token: widget.token,
                                          ))).then((value) => setState(() {
                                    fetchUser();
                                  }));
                            }),
                      );
                    },
                  ),
                ))
              : Container(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                context;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChildSetup(
                            parent_username: parent_username,
                            token: token,
                          )),
                );
              },
              child: Text('Add a Child'),
            ),
          )
        ]),
      ),
      Image.asset(
        'assets/images/side_image.JPG',
        width: 200,
        height: 1000,
      ),
    ]);
  }
}
