import 'package:flutter/material.dart';
import 'package:expense_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'package:expense_tracker/ui/mainScreen/homeScreen.dart';
import '../../floorDatabase/database/database.dart'; // Adjust the import according to your structure

class AppRoutes {
  static const String loginRegister = '/login_register';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final AppDatabase? appDatabase = settings.arguments as AppDatabase?;

    if (appDatabase == null) {
      return _errorRoute(); // or handle accordingly
    }

    switch (settings.name) {
      case loginRegister:
        return MaterialPageRoute(
          builder: (_) => LoginRegisterView(appDatabase: appDatabase),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(appDatabase: appDatabase),
        );
      default:
        return _errorRoute();
    }
  }


  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR: No route defined for this path'),
          ),
        );
      },
    );
  }
}
