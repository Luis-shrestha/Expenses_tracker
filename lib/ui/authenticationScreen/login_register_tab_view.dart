import 'package:flutter/material.dart';
import 'package:expense_tracker/configs/palette.dart';
import 'package:expense_tracker/configs/iconsConstant.dart';
import 'package:expense_tracker/ui/authenticationScreen/loginScreen.dart';
import 'package:expense_tracker/ui/authenticationScreen/registerScreen.dart';

import '../../floorDatabase/database/database.dart';

class LoginRegisterView extends StatefulWidget {
  final AppDatabase appDatabase;
  const LoginRegisterView({super.key, required this.appDatabase});

  @override
  State<LoginRegisterView> createState() => _LoginRegisterViewState();
}

class _LoginRegisterViewState extends State<LoginRegisterView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.appDatabase.registerDao.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.primaryColor,
                ),
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 25,
                          child: IconsConstant.loginIcon,
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Register"),
                        SizedBox(width: 10),
                        SizedBox(
                          height: 25,
                          child: IconsConstant.registerIcon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    LoginScreen(appDatabase: widget.appDatabase,),
                    RegisterScreen(appDatabase: widget.appDatabase,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
