import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'account.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home.dart';
import 'models.dart';

late final db;
late FirebaseAuth firebaseAuth;
late FirebaseStorage storage;
late final sharedPref;
bool isLoggedIn = false;
int selectedIndex = 0;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // included to make the main function async

  // initialise Hive local database
  await Hive.initFlutter();
  // Register adapters for each model
  Hive.registerAdapter(CartAdapter());
  // Open hive box
  await Hive.openBox<Cart>('cart_box');

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

  runApp(
    MaterialApp(home: Home()),
  );

  /* if (isLoggedIn) {
    runApp(
      MaterialApp(home: Home()),
    );
  } else {
    runApp(
      MaterialApp(home: Login()),
    );
  } */
}
