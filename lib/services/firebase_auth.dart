import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:flutter/material.dart';

class FirebaseAuthUser {
  final auth = FirebaseAuth.instance;
  Future<void> signIn(email, password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      log("Rainiel login $userCredential");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signInUsingNumber(number) async {
    // final completer = Completer<AuthCredential>();
    await auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("verification completed $number");
        // completer.complete;
      },
      verificationFailed: (FirebaseAuthException e) {
        print("verification failed $number, $e");
        // completer.completeError;
      },
      codeSent: (String verificationId, int resendToken) async {
        print("verification code sent $number $verificationId $resendToken");
        // PhoneAuthCredential phoneAuthCredential =
        //     PhoneAuthProvider.credential(
        //         verificationId: verificationId, smsCode: smsCode);
        // await auth.signInWithCredential(phoneAuthCredential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("verification code auto retreival timeout $number");
      },
    );
    return "Rainiel v";
  }
}
