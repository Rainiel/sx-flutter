import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:boilerplate/services/firebase_db.dart';

class StepperPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<StepperPage> {
  var myInstance = new BodyInstance();
  int _currentStep = 0;
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

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  _getDevices() async {
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
    _getDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Storage X ')),
        // drawer: CustomDrawer(),
        body: Body(_currentStep, myInstance, box, devices),
        bottomNavigationBar: BottomNav(
            continued: continued,
            cancel: cancel,
            step: _currentStep,
            instance: myInstance,
            box: box));
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
  final int _currentStep;
  final myInstance;
  final box;
  final devices;
  Body(this._currentStep, this.myInstance, this.box, this.devices);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // int _currentStep = 0;
  // var selectedDevice;
  // var myInstance = new BodyInstance();
  var colorG = Colors.green[400];
  // var devices = [];
  var selectedBoxIndex = null;
  final icons = IconData(0xe593, fontFamily: 'MaterialIcons');

  // _getDevices() async {
  //   List array = [];
  //   await FirebaseDatabase.instance
  //       .reference()
  //       .child("device")
  //       .once()
  //       .then((DataSnapshot snapshot) {
  //     Map<dynamic, dynamic>.from(snapshot.value).forEach((key, values) {
  //       array.add({"id": key, ...values, "selected": false});
  //     });
  //   });
  //   setState(() {
  //     print(array);
  //     devices = array;
  //   });
  // }

  // @override
  // void initState() {
  //   _getDevices();
  //   super.initState();
  // }

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
                      itemCount: widget.devices.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: widget.devices[index]["selected"]
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
                            title: Text(widget.devices[index]["location"]),
                            trailing: Checkbox(
                                value: widget.devices[index]["selected"],
                                onChanged: (value) {}),
                            onTap: () {
                              setState(() {
                                widget.devices[index]["selected"] =
                                    !widget.devices[index]["selected"];
                                widget.myInstance.device =
                                    widget.devices[index];
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
                        onChanged: (value) {
                          setState(() {
                            widget.myInstance.info.yourname = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Your Name'),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            widget.myInstance.info.yourcontact = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Your Contact'),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            widget.myInstance.info.cname = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Claimant Name'),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            widget.myInstance.info.ccontact = value;
                          });
                        },
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
                      itemCount: widget.myInstance.device == null ? 0 : widget.myInstance.device["locker"].length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => {
                                if (selectedBoxIndex == null)
                                  {
                                    setState(() {
                                      selectedBoxIndex = index;
                                      widget.myInstance.device["locker"][index][0]["status"] = true;
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      widget.myInstance.device["locker"][selectedBoxIndex][0]
                                          ["status"] = false;
                                      widget.myInstance.device["locker"][selectedBoxIndex][1]
                                          ["status"] = false;
                                      selectedBoxIndex = index;
                                      widget.myInstance.device["locker"][index][0]["status"] = true;
                                    })
                                  }
                              },
                              child: Container(
                                  decoration: widget.myInstance.device["locker"][index][0]["status"] ==
                                          true
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
                                        child: Text(widget.myInstance.device["locker"][index][0]["box"]
                                            .toString())),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () => {
                                if (selectedBoxIndex == null)
                                  {
                                    setState(() {
                                      selectedBoxIndex = index;
                                      widget.myInstance.device["locker"][index][1]["status"] = true;
                                    })
                                  }
                                else
                                  {
                                    setState(() {
                                      widget.myInstance.device["locker"][selectedBoxIndex][0]
                                          ["status"] = false;
                                      widget.myInstance.device["locker"][selectedBoxIndex][1]
                                          ["status"] = false;
                                      selectedBoxIndex = index;
                                      widget.myInstance.device["locker"][index][1]["status"] = true;
                                    })
                                  }
                              },
                              child: Container(
                                decoration:
                                    widget.myInstance.device["locker"][index][1]["status"] == true
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
                                      child: Text(widget.myInstance.device["locker"][index][1]["box"]
                                          .toString())),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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
  final instance;
  final box;
  // BottomNav(this.continued);
  const BottomNav(
      {Key key,
      this.continued,
      this.cancel,
      this.step,
      this.instance,
      this.box})
      : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  void _itemTapped(int index) {
    print(widget.step);
    if (widget.step >= 2) {
      widget.instance.locker = widget.box;
      print(widget.instance.getValue());
      FirebaseDb().saveLocker(widget.instance.device, widget.instance.locker);
    }
    index == 1 ? widget.continued() : widget.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Cancel',
          ),
          widget.step >= 2
              ? BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Finish',
                )
              : BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Next',
                ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.black38,
        onTap: _itemTapped,
      ),
    );
  }
}
