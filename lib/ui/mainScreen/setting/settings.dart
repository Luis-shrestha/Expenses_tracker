import 'package:flutter/material.dart';
import 'package:expense_tracker/ui/mainScreen/setting/widgets/customSettingColumn.dart';
import 'package:expense_tracker/ui/mainScreen/setting/widgets/security.dart';

import '../../../floorDatabase/database/database.dart';
import '../../../utility/routeTransition.dart';
import '../profile/profileView.dart';

class Settings extends StatefulWidget {
  final AppDatabase appDatabase;
  final int userId;
  const Settings({super.key, required this.appDatabase, required this.userId});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomSettingColumn(
              icon: Icons.person,
              title: "Your Profile",
              subTitle: "view your profile",
              color: Colors.black,
              onTap: (){
                Navigator.of(context).push(
                  customPageRouteFromRight(ProfileView(appDatabase: widget.appDatabase,)),
                );
              },
            ),
            CustomSettingColumn(
              icon: Icons.security,
              title: "Security",
              subTitle: "use biometrics",
              color: Colors.black,
              onTap: (){
                Navigator.of(context).push(
                  customPageRouteFromRight(Security(appDatabase: widget.appDatabase,)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
