// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/notificationPage/notificationPage.dart';
import 'package:expense_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'package:expense_tracker/ui/mainScreen/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Login and navigation flow test', (WidgetTester tester) async {
    // Initialize app with mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      'username': 'user',
      'password': 'password123',
    });

    // Initialize the actual AppDatabase (you might need a test database setup here)
    final appDocDir = await getApplicationDocumentsDirectory();
    final dbPath = "${appDocDir.path}/test.db";
    final appDatabase = await $FloorAppDatabase.databaseBuilder(dbPath).build();

    // Build the app and trigger a frame
    await tester.pumpWidget(MyApp(appDatabase: appDatabase, isLoggedIn: true));

    // Verify that we are on the HomeScreen after login
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginRegisterView), findsNothing);

    // Tap the notification icon
    await tester.tap(find.byIcon(Icons.notifications));
    await tester.pumpAndSettle();

    // Verify that we are navigating to the notification page
    expect(find.byType(NotificationPage), findsOneWidget);
  });
}
