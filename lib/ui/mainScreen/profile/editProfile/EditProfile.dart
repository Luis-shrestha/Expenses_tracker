import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';
import 'package:expense_tracker/utility/applog.dart';
import '../../../../configs/dimension.dart';
import '../../../../floorDatabase/database/database.dart';
import '../../../../supports/utils/sharedPreferenceManager.dart';
import '../../../../utility/ToastUtils.dart';
import '../../../custom/customProceedButton.dart';
import '../../../reusableWidget/customTextFormField.dart';

class EditProfileView extends StatefulWidget {
  final AppDatabase appDatabase;
  final Function updateUserDetails;
  final RegisterEntity? registerEntity;

  const EditProfileView(
      {super.key,
      required this.appDatabase,
      required this.updateUserDetails,
      this.registerEntity});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var key = GlobalKey<FormState>();

  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Please Enter email";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppLog.i("User ID", "${widget.registerEntity!.id}, ${widget.registerEntity!.userName}");
    if (widget.registerEntity != null) {
      userNameController.text = widget.registerEntity!.userName;
      emailController.text = widget.registerEntity!.email;
      contactController.text = widget.registerEntity!.contact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(doublePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 32.0),
                form(),
                SizedBox(height: 32.0),
                button(),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Form(
      key: key,
      child: Column(
        children: [
          CustomTextFormField(
            line: 1,
            controller: userNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter username";
              }
              return null;
            },
            hintText: 'Enter your userName',
            labelText: 'username',
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 8.0),
          CustomTextFormField(
            line: 1,
            controller: emailController,
            validator: emailValidator,
            hintText: 'Enter your email',
            labelText: 'email',
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 8.0),
          CustomTextFormField(
            line: 1,
            controller: contactController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter contact";
              }
              return null;
            },
            hintText: 'Enter your contact',
            labelText: 'contact',
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        save();
      },
      child: CustomProceedButton(titleName: 'Update'),
    );
  }

  void save() async {
    if (key.currentState!.validate()) {
      try {
        RegisterEntity registerEntity = RegisterEntity(
          id: widget.registerEntity!.id,
          userName: userNameController.text,
          contact: contactController.text,
          email: emailController.text,
          password: widget.registerEntity!.password,
        );
        await widget.appDatabase.registerDao.updateUser(registerEntity);
        await SharedPreferenceManager.setUsername( userNameController.text);
        // Success feedback
        Toastutils.showToast( 'Updated Successfully');
        widget.updateUserDetails();
        Navigator.pop(context);
      } catch (e) {
        print('Error inserting user: $e'); // Log error
        // Handle error feedback
        Toastutils.showToast( 'Something went wrong');
      }
    }
  }
}
