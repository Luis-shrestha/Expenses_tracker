import 'package:flutter/material.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';
import 'package:expense_tracker/utility/applog.dart';

import '../../../../floorDatabase/database/database.dart';
import '../../../../floorDatabase/entity/registerEntity.dart';
import '../../../../supports/utils/sharedPreferenceManager.dart';
import '../../../../utility/textStyle.dart';

class Security extends StatefulWidget {
  final AppDatabase appDatabase;

  const Security({
    super.key,
    required this.appDatabase,
  });

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {

  RegisterEntity? user;
  bool isLoading = true;
  bool _isFingerprintEnable = false;

  @override
  void initState() {
    super.initState();
    _loadFingerprintSetting();
    getUserData();
  }

  Future<void> _loadFingerprintSetting() async {
    // Retrieve the stored value for fingerprint setting
    bool savedValue = await SharedPreferenceManager.getFingerPrintFirstView();
    setState(() {
      _isFingerprintEnable = savedValue;
    });
  }

  Future<void> getUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch username and password from shared preferences
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();

      if (username != null && password != null) {
        user = await widget.appDatabase.registerDao
            .getUserByUsernameAndPassword(username, password);

      } else {
        throw Exception("Username or password is missing.");
      }
    } catch (e) {
      print("Error loading user data: $e");
      Toastutils.showToast('Failed to load user data');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Security"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Use Fingerprint",
                        style: mediumTextStyle(
                          textColor: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text("Use Fingerprint for easier login "),
                    ],
                  ),
                  Switch(
                    value: _isFingerprintEnable,
                    onChanged: (value) {
                      
                      _updateFingerprintSetting(value);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateFingerprintSetting(bool value) async {

    if(value && user != null){
      await SharedPreferenceManager.setUsername(user!.userName);
      await SharedPreferenceManager.setPassword(user!.password);
      AppLog.d("username and password", "${user!.userName}, ${user!.password}");
      await SharedPreferenceManager.setFingerPrintFirstView(value);
      setState(() {
        _isFingerprintEnable = value;
      });
      Toastutils.showToast('Fingerprint ${value ? "enabled" : "disabled"}');
    }else{
      Toastutils.showToast("Please load user data first.");
    }

  }
}
