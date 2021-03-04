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
  int _currentStep = 0;
  var colorG = Colors.green[400];
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
              onStepTapped: (step) => tapped(step),
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
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
                  state: _currentStep >= 0
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
                                onTap: () => setState(() => colorG = Colors.teal[500]),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text('Box 2'),
                                  color: colorG,
                                ),
                              ),
                              InkWell(
                                onTap: () => print("Container 2 pressed"),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: 40,
                                  // padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: 8),
                                  child: Text('Box 1'),
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
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: new Text('Mobile Number'),
                  content: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Mobile Number'),
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
