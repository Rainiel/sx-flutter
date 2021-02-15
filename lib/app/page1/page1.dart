import 'package:flutter/material.dart';

const mainColor = Color(0xff2470c7);

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomPadding: false, body: page1(context));
  }

  Widget page1(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 15),
                child: Text(
                  "page1",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 20,
                  ),
                ),
              ),
            ],
          )
        ],
      )
    ]));
  }
}