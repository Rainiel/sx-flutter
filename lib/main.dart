import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boilerplate/app/home/tabs.dart';
import 'package:boilerplate/app/sign_in/sign_in.dart';
import 'package:boilerplate/app/page1/page1.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: FBbuild(
      //   nonSignedInBuilder: (_) => SignIn(),
      //   signedInBuilder: (_) => TabsPage(),
      // ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => FBbuild(),
        '/signIn': (BuildContext context) => SignIn(),
        '/page1': (BuildContext context) => Page1(),
        '/home': (BuildContext context) => TabsPage(),
      },
    );
  }
}

class FBbuild extends StatelessWidget {
  // const FBbuild({
  //   Key key,
  //   @required this.signedInBuilder,
  //   @required this.nonSignedInBuilder,
  // }) : super(key: key);
  // final WidgetBuilder nonSignedInBuilder;
  // final WidgetBuilder signedInBuilder;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth.instance.authStateChanges().listen((User user) {
            // print("main.dart $user");
            if (user == null) {
              print("user null");
              // return nonSignedInBuilder(context);
              Navigator.of(context).pushNamed('/signIn');
            } else {
              print("user not null");
              // return signedInBuilder(context);
              Navigator.of(context).pushNamed('/home');
            }
          });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading(context);
      },
    );
  }

  // @override
  Widget myAwesomeApp() {
    return SignIn();
  }

  Widget somethingWentWrong(context) {
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
                  "Something Went Wrong",
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

  Widget loading(context) {
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
                  "Loading",
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
