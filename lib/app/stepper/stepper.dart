import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:firebase_database/firebase_database.dart';

class StepperPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<StepperPage> {
  int _currentStep = 0;

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Storage X ')),
      // drawer: CustomDrawer(),
      body: Body(_currentStep),
      bottomNavigationBar:
          BottomNav(continued: continued, cancel: cancel, step: _currentStep),
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

class BodyInstance {
  var device;
  var info;
  var locker;

  getValue() {
    return {"device": device, "info": info, "locker": locker};
  }
}

class Body extends StatefulWidget {
  int _currentStep;
  Body(this._currentStep);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // int _currentStep = 0;
  // var selectedDevice;
  var myInstance = new BodyInstance();
  var colorG = Colors.green[400];
  var devices = [];
  var box = [
    [
      {"box": 1, "status": false},
      {"box": 2, "status": false}
    ],
    [
      {"box": 3, "status": false},
      {"box": 4, "status": false}
    ],
    [
      {"box": 5, "status": false},
      {"box": 6, "status": false}
    ]
  ];
  var selectedBoxIndex = null;
  final icons = IconData(0xe593, fontFamily: 'MaterialIcons');

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
              currentStep: widget._currentStep,
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
                  content: Expanded(
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
                                myInstance.device = devices[index];
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  isActive: widget._currentStep >= 0,
                  state: widget._currentStep >= 0
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
                  isActive: widget._currentStep >= 0,
                  state: widget._currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: new Text('Locker'),
                  content: ListView.builder(
                      shrinkWrap: true,
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => {
                                if (selectedBoxIndex == null)
                                  {
                                    setState(() => {
                                          selectedBoxIndex = index,
                                          box[index][0]["status"] = true
                                        })
                                  }
                                else
                                  {
                                    setState(() => {
                                          box[selectedBoxIndex][0]["status"] =
                                              false,
                                          box[selectedBoxIndex][1]["status"] =
                                              false,
                                          selectedBoxIndex = index,
                                          box[index][0]["status"] = true
                                        })
                                  }
                              },
                              child: Container(
                                  decoration: box[index][0]["status"] == true
                                      ? BoxDecoration(
                                          color: Colors.green[400],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)))
                                      : BoxDecoration(
                                          color: Colors.teal[400],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height: 50,
                                  margin: EdgeInsets.only(right: 4, bottom: 8),
                                  child: Container(
                                    child: Center(
                                        child: Text(
                                            box[index][0]["box"].toString())),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () => {
                                if (selectedBoxIndex == null)
                                  {
                                    setState(() => {
                                          selectedBoxIndex = index,
                                          box[index][1]["status"] = true
                                        })
                                  }
                                else
                                  {
                                    setState(() => {
                                          box[selectedBoxIndex][0]["status"] =
                                              false,
                                          box[selectedBoxIndex][1]["status"] =
                                              false,
                                          selectedBoxIndex = index,
                                          box[index][1]["status"] = true
                                        })
                                  }
                              },
                              child: Container(
                                decoration: box[index][1]["status"] == true
                                    ? BoxDecoration(
                                        color: Colors.green[400],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))
                                    : BoxDecoration(
                                        color: Colors.teal[400],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                width: MediaQuery.of(context).size.width * 0.40,
                                height: 50,
                                margin: EdgeInsets.only(left: 4, bottom: 8),
                                child: Container(
                                  child: Center(
                                      child: Text(
                                          box[index][1]["box"].toString())),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  // content: Stack(
                  //   children: <Widget>[
                  //     Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: <Widget>[
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             InkWell(
                  //               onTap: () =>
                  //                   setState(() => colorG = Colors.teal[500]),
                  //               child: Container(
                  //                   decoration: BoxDecoration(
                  //                       color: colorG,
                  //                       borderRadius: BorderRadius.all(
                  //                           Radius.circular(10))),
                  //                   width: MediaQuery.of(context).size.width *
                  //                       0.40,
                  //                   height: 40,
                  //                   margin:
                  //                       EdgeInsets.only(right: 4, bottom: 8),
                  //                   child: Container(
                  //                     child: Center(child: Text("box1")),
                  //                   )),
                  //             ),
                  //             InkWell(
                  //               onTap: () => print("Container 2 pressed"),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                     color: colorG,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(10))),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.40,
                  //                 height: 40,
                  //                 margin: EdgeInsets.only(left: 4, bottom: 8),
                  //                 child: Container(
                  //                   child: Center(child: Text("box1")),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             InkWell(
                  //               onTap: () =>
                  //                   setState(() => colorG = Colors.teal[500]),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                     color: colorG,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(10))),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.40,
                  //                 height: 40,
                  //                 margin: EdgeInsets.only(right: 4, bottom: 8),
                  //                 child: Container(
                  //                   child: Center(child: Text("box1")),
                  //                 ),
                  //               ),
                  //             ),
                  //             InkWell(
                  //               onTap: () => print("Container 2 pressed"),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                     color: colorG,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(10))),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.40,
                  //                 height: 40,
                  //                 margin: EdgeInsets.only(left: 4, bottom: 8),
                  //                 child: Container(
                  //                   child: Center(child: Text("box1")),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: <Widget>[
                  //             InkWell(
                  //               onTap: () =>
                  //                   setState(() => colorG = Colors.teal[500]),
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                                                         color: colorG,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(10))),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.40,
                  //                 height: 40,
                  //                 margin: EdgeInsets.only(right: 4, bottom: 8),
                  //                 child: Container(
                  //                   child: Center(child: Text("box1")),
                  //                 ),
                  //               ),
                  //             ),
                  //             InkWell(
                  //               onTap: () => {print(myInstance.getValue())},
                  //               child: Container(
                  //                 decoration: BoxDecoration(
                  //                     color: colorG,
                  //                     borderRadius: BorderRadius.all(
                  //                         Radius.circular(10))),
                  //                 width:
                  //                     MediaQuery.of(context).size.width * 0.40,
                  //                 height: 40,
                  //                 margin: EdgeInsets.only(left: 4, bottom: 8),
                  //                 child: Container(
                  //                   child: Center(child: Text("box1")),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  isActive: widget._currentStep >= 0,
                  state: widget._currentStep >= 2
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

class BottomNav extends StatefulWidget {
  final Function continued;
  final Function cancel;
  final int step;
  // BottomNav(this.continued);
  const BottomNav({Key key, this.continued, this.cancel, this.step})
      : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  void _itemTapped(int index) {
    print(widget.step);
    if (widget.step >= 2) {
      print("finish");
    }
    index == 1 ? widget.continued() : widget.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Cancel',
          backgroundColor: Colors.red,
        ),
        widget.step >= 2
            ? BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Finish',
                backgroundColor: Colors.green,
              )
            : BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Next',
                backgroundColor: Colors.green,
              ),
      ],
      currentIndex: 1,
      // selectedItemColor: Colors.amber[800],
      onTap: _itemTapped,
    );
  }
}
