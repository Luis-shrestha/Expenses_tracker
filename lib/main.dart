import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/firebaseApis/firebaseApi.dart';
import 'package:expense_tracker/supports/utils/sharedPreferenceManager.dart';
import 'package:expense_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'floorDatabase/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/ui/mainScreen/homeScreen.dart';
import 'notificationPage/notificationPage.dart';
import 'dart:io';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  // Get the application documents directory
  final appDocDir = await getApplicationDocumentsDirectory();
  final dbPath = "${appDocDir.path}/finance_tracker.db";

  // Check if the database exists, and delete it if it does
/*  final dbFile = File(dbPath);
  if (await dbFile.exists()) {
    // If the database exists, delete it and force a rebuild
    await dbFile.delete();
    print("Database deleted. Rebuilding...");
  }*/

  // Initialize the database with migrations
  final appDatabase = await $FloorAppDatabase.databaseBuilder(dbPath)
      .addMigrations([migration1to2, migration2to3])  // Add your migrations here
      .build();

  // Check for existing username and password in SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedUsername = prefs.getString(SharedPreferenceManager.username);
  String? storedPassword = prefs.getString(SharedPreferenceManager.password);

  // Ensure isLoggedIn is a boolean value
  bool isLoggedIn = (storedUsername != null && storedUsername.isNotEmpty) &&
      (storedPassword != null && storedPassword.isNotEmpty);

  // Run the app
  runApp(MyApp(
    appDatabase: appDatabase,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;
  final bool isLoggedIn;

  const MyApp({super.key, required this.appDatabase, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      routes: {
        '/notificationPage': (context) => NotificationPage(),
      },
      home: isLoggedIn
          ? HomeScreen(appDatabase: appDatabase)
          : LoginRegisterView(appDatabase: appDatabase),
    );
  }
}
