import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Startup Name Generator')),
      drawer: CustomDrawer(),
      body: Body(),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Page 1'),
            onTap: () {
              Navigator.of(context).pushNamed('/page1');
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var titles = [];
  final icons = IconData(0xe593, fontFamily: 'MaterialIcons');

  _getData() async {
    List array = [];
    await FirebaseDatabase.instance
        .reference()
        .child("device")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic>.from(snapshot.value).forEach((key, values) {
        array.add({"id": key, ...values});
      });
    });
    setState(() {
      print(array);
      titles = array;
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Icon(icons),
            title: Text(titles[index]["location"]),
            onTap: () {
              Navigator.of(context).pushNamed("/stepper");
            },
          ),
        );
      },
    );
  }
}
