import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';

class FirebaseDb {
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> saveLocker(device, locker) async {
    try {
      var deviceId = device["id"];
      log('$deviceId');
      log('$locker');
      databaseReference.child('device/$deviceId/locker').set(device["locker"]);
    } catch (e) {}
  }
}
