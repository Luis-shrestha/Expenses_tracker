import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/configs/dimension.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';
import 'package:expense_tracker/ui/custom/customProceedButton.dart';
import 'package:expense_tracker/ui/reusableWidget/customTextFormField.dart';
import 'package:expense_tracker/utility/ToastUtils.dart';

import '../../floorDatabase/database/database.dart';
import '../../utility/applog.dart';
import '../../utility/textStyle.dart';

class RegisterScreen extends StatefulWidget {
  final AppDatabase appDatabase;
  const RegisterScreen({super.key, required this.appDatabase});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var key = GlobalKey<FormState>();

  bool _obscurePassword = false;

  void reset() {
    userNameController.clear();
    emailController.clear();
    contactController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(doublePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Register Here",
                    style: largeTextStyle(
                      textColor: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  form(),
                  SizedBox(height: 32.0),
                  button(),
                  SizedBox(height: 16.0),
                  registerText(),
                ],
              ),
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
            controller: userNameController,
            validator: (value) => value!.isEmpty ? "Please Enter username" : null,
            hintText: 'Enter your userName',
            labelText: 'username',
            prefixIcon: Icons.person, line: 1,
          ),
          CustomTextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) return "Please Enter email";
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) return "Invalid email format";
              return null;
            },
            hintText: 'Enter your email',
            labelText: 'email',
            prefixIcon: Icons.email, line: 1,
          ),
          CustomTextFormField(
            controller: contactController,
            validator: (value) => value!.isEmpty ? "Please Enter contact" : null,
            hintText: 'Enter your contact',
            labelText: 'contact',
            prefixIcon: Icons.phone, line: 1,
          ),
          CustomTextFormField(
            controller: passwordController,
            validator: (value) => value!.isEmpty ? "Please Enter password" : null,
            hintText: 'Enter your password',
            labelText: 'password',
            prefixIcon: Icons.lock,
            suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
            suffixIconOnPressed: _togglePasswordVisibility,
            obscureText: _obscurePassword, line: 1,
          ),
          CustomTextFormField(
            controller: confirmPasswordController,
            validator: (value) {
              if (value!.isEmpty) return "Please confirm your password";
              if (value != passwordController.text) return "Passwords do not match";
              return null;
            },
            hintText: 'Confirm your password',
            labelText: 'Confirm password',
            prefixIcon: Icons.lock,
            obscureText: _obscurePassword, line: 1,
          ),
        ],
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        register();
        reset();
      },
      child: CustomProceedButton(titleName: 'Register'),
    );
  }

  Widget registerText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ", style: regularTextStyle(textColor: Colors.black, fontSize: 15)),
        GestureDetector(
          onTap: () {
            // Navigate to the login page or tab
            final tabController = DefaultTabController.of(context);
            if (tabController != null) {
              tabController.animateTo(0);
            }
          },
          child: Text("Login Here", style: regularTextStyle(textColor: Colors.red, fontSize: 15)),
        ),
      ],
    );
  }

  void register() async {
    if (key.currentState!.validate()) {
      try {
        // Hash the password
        String hashedPassword = hashPassword(passwordController.text);

        RegisterEntity registerEntity = RegisterEntity(
          userName: userNameController.text,
          contact: contactController.text,
          email: emailController.text,
          password: hashedPassword,
        );

        AppLog.d("registerEntity", "${registerEntity.userName} ${registerEntity.password}");

        // Insert into the database
        await widget.appDatabase.registerDao.insertUser(registerEntity);

        // Success feedback
        Toastutils.showToast('Registered Successfully');
        final tabController = DefaultTabController.of(context);
        if (tabController != null) {
          tabController.animateTo(0);
        }
      } catch (e) {
        print('Error inserting user: $e');
        Toastutils.showToast('Registration failed');
      }
    }
  }
}
