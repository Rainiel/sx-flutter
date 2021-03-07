import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:firebase_database/firebase_database.dart';

class StepperPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<StepperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Storage X ')),
      // drawer: CustomDrawer(),
      body: Body(),
      bottomNavigationBar: BottomNav(),
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
  int _currentStep = 0;
  var colorG = Colors.green[400];
  var devices = [];
  var selectedDevice;
  final icons = IconData(0xe593, fontFamily: 'MaterialIcons');

  StepperType stepperType = StepperType.vertical;
  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  _getData() async {
    List array = [];
    await FirebaseDatabase.instance
        .reference()
        .child("device")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic>.from(snapshot.value).forEach((key, values) {
        array.add({"id": key, ...values, "selected": false});
      });
    });
    setState(() {
      print(array);
      devices = array;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              physics: ScrollPhysics(),
              currentStep: _currentStep,
              // onStepTapped: (step) => tapped(step),
              // onStepContinue: continued,
              // onStepCancel: cancel,
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return Row(
                  children: <Widget>[
                    Container(
                      child: null,
                    ),
                    Container(
                      child: null,
                    ),
                  ],
                );
              },
              steps: <Step>[
                Step(
                  title: new Text('Devices'),
                  content: Stack(children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: devices[index]["selected"]
                                ? new RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(4.0))
                                : new RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(4.0)),
                            child: ListTile(
                              leading: Icon(icons),
                              title: Text(devices[index]["location"]),
                              trailing: Checkbox(
                                  value: devices[index]["selected"],
                                  onChanged: (value) {}),
                              onTap: () {
                                setState(() {
                                  devices[index]["selected"] =
                                      !devices[index]["selected"];
                                  selectedDevice = devices[index];
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: new Text('Info'),
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Your Name'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Your Contact'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Claimant Name'),
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Claimant Contact'),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: new Text('Locker'),
                  // content: Container(
                  //   padding: const EdgeInsets.all(8),
                  //   child: Text('Box 1'),
                  //   color: Colors.teal[500],
                  // ),
                  content: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () =>
                                    setState(() => colorG = Colors.teal[500]),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 4, bottom: 8),
                                  child: Text('Box 1'),
                                  color: colorG,
                                ),
                              ),
                              InkWell(
                                onTap: () => print("Container 2 pressed"),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text('Box 2'),
                                  color: Colors.teal[500],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () =>
                                    setState(() => colorG = Colors.teal[500]),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 4, bottom: 8),
                                  child: Text('Box 3'),
                                  color: colorG,
                                ),
                              ),
                              InkWell(
                                onTap: () => print("Container 2 pressed"),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text('Box 4'),
                                  color: Colors.teal[500],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () =>
                                    setState(() => colorG = Colors.teal[500]),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(right: 4, bottom: 8),
                                  child: Text('Box 5'),
                                  color: colorG,
                                ),
                              ),
                              InkWell(
                                onTap: () => print("Container 2 pressed"),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: 4, bottom: 8),
                                  child: Text('Box 6'),
                                  color: Colors.teal[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Cancel',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Next',
          backgroundColor: Colors.green,
        ),
      ],
      currentIndex: 1,
      // selectedItemColor: Colors.amber[800],
      // onTap: _BodyState.continued(),
    );
  }
}
