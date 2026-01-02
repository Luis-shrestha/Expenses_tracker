import 'package:flutter/material.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';
import 'package:expense_tracker/supports/utils/sharedPreferenceManager.dart';
import 'package:expense_tracker/ui/mainScreen/profile/editProfile/EditProfile.dart';
import 'package:expense_tracker/ui/mainScreen/profile/widgets/CustomProfileDataContainer.dart';
import 'package:expense_tracker/utility/applog.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import '../../../utility/routeTransition.dart';

class ProfileView extends StatefulWidget {
  final AppDatabase appDatabase;

  const ProfileView({super.key, required this.appDatabase});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  RegisterEntity? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();

      AppLog.d("user details", "$username, $password");

      if (username != null && password != null) {
        user = await widget.appDatabase.registerDao.getUserByUsernameAndPassword(username, password);
      }
    } catch (e) {
      print("Error loading user data: $e");
      // Show a Snackbar or AlertDialog for the error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
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
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildUserData(),
            _buildProfileSetting(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserData() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: doublePadding),
      color: Colors.white,
      child: Column(
        children: [
          CircleAvatar(
            minRadius: 50,
            child: Icon(Icons.person, size: 60),
          ),
          SizedBox(height: 16),
          Text(
            user?.userName ?? "No user details found",
            style: mediumTextStyle(textColor: Colors.black, fontSize: 25),
          ),
          if (user?.email != null)
            Text(
              user!.email,
              style: mediumTextStyle(textColor: Colors.black54, fontSize: 17),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileSetting() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: halfMargin),
      padding: EdgeInsets.symmetric(vertical: doublePadding, horizontal: padding),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Settings",
            style: regularTextStyle(textColor: Colors.black54, fontSize: 15),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                customPageRouteFromRight(EditProfileView(appDatabase: widget.appDatabase, updateUserDetails: getUserData,registerEntity: user,)),
              );
            },
            child: CustomProfileDataContainer(
              title: 'Your Data',
              subTitle: 'Update and modify your profile data',
              icon: Icons.person,
            ),
          ),
        ],
      ),
    );
  }
}
