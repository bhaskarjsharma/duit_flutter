import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'account.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

late final db;
late FirebaseAuth firebaseAuth;
late FirebaseStorage storage;
late final sharedPref;
bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // included to make the main function async
  // Firebase initilization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialise Firbase AUthentication
  firebaseAuth = FirebaseAuth.instance;
  // initialise firebase firestor
  db = FirebaseFirestore.instance;

  storage = FirebaseStorage.instance;

  sharedPref = await SharedPreferences.getInstance();

  isLoggedIn = sharedPref.getBool('isLoggedIn') ?? false;

  if (isLoggedIn) {
    runApp(
      MaterialApp(home: Home()),
    );
  } else {
    runApp(
      MaterialApp(home: Login()),
    );
  }
}
