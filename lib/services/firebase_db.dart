import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer';

class FirebaseDb {
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<void> saveLocker(device, locker) async {
    try {
      var deviceId = device["id"];
      List deviceLocker = device["locker"];
      log('$deviceId');
      for (int i = 0; i < deviceLocker.length; i++) {
        for (int k = 0; k < 2; k++) {
          if (deviceLocker[i][k].containsKey('selected')) {
            if (deviceLocker[i][k]["selected"]) {
              deviceLocker[i][k]["status"] = true;
              deviceLocker[i][k].remove("selected");
            } else {
              deviceLocker[i][k].remove("selected");
            }
          }
        }
      }
      log('$deviceLocker');
      
      // databaseReference.child('device/$deviceId/locker').set(device["locker"]);
    } catch (e) {}
  }
}
