import 'package:boilerplate/app/sign_up/sign_up.dart';
import 'package:boilerplate/app/stepper/stepper.dart';
import 'package:boilerplate/app/verify/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boilerplate/app/home/tabs.dart';
import 'package:boilerplate/app/sign_in/sign_in.dart';
import 'package:boilerplate/app/page1/page1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: Fire(),
      routes: <String, WidgetBuilder>{
        // '/': (BuildContext context) => FBbuild(),
        // '/signIn': (BuildContext context) => SignIn(),
        // '/loader': (BuildContext context) => Loader(),
        '/verifyNumber': (BuildContext context) => Verify(),
        '/page1': (BuildContext context) => Page1(),
        '/signup': (BuildContext context) => SignUp(),
        '/home': (BuildContext context) => TabsPage(),
        '/stepper': (BuildContext context) => StepperPage(),
      },
    );
  }
}

class Fire extends StatefulWidget {
  @override
  _FireState createState() => _FireState();
}

class _FireState extends State<Fire> {
  Widget initialPage = Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        setState(() {
          initialPage = SignIn();
        });
      } else {
        setState(() {
          initialPage = TabsPage();
        });
      }
    });
    return initialPage;
  }
}

// class FBbuild extends StatelessWidget {
//   FBbuild({
//     Key key,
//     @required this.signedInBuilder,
//     @required this.nonSignedInBuilder,
//     @required this.loader,
//   }) : super(key: key);
//   final WidgetBuilder nonSignedInBuilder;
//   final WidgetBuilder signedInBuilder;
//   final WidgetBuilder loader;
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: _initialization,
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return somethingWentWrong(context);
//         }

//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           FirebaseAuth.instance.authStateChanges().listen((User user) {
//             // print("main.dart $user");
//             if (user == null) {
//               print("user null");
//               // Navigator.pop(context);
//               // return nonSignedInBuilder(context);
//               return SignIn();
//               // Navigator.of(context).pushNamed('/signIn');
//             } else {
//               print("user not null");
//               // Navigator.pop(context);
//               // return signedInBuilder(context);
//               return TabsPage();
//               // Navigator.of(context).pushNamed('/home');
//             }
//           });
//         }

//         // Otherwise, show something whilst waiting for initialization to complete
//         print("loading");
//         // return loader(context);
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }

//   // @override
//   Widget myAwesomeApp() {
//     return SignIn();
//   }

//   Widget somethingWentWrong(context) {
//     return Scaffold(
//         body: Stack(children: <Widget>[
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height / 15),
//                 child: Text(
//                   "Something Went Wrong",
//                   style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.height / 20,
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       )
//     ]));
//   }

//   Widget loading(context) {
//     return Scaffold(
//         body: Stack(children: <Widget>[
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height / 15),
//                 child: Text(
//                   "Loading",
//                   style: TextStyle(
//                     fontSize: MediaQuery.of(context).size.height / 20,
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       )
//     ]));
//   }
// }

// class Loader extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
