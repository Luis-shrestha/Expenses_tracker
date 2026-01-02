// user_data_service.dart
import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';
import '../../supports/utils/sharedPreferenceManager.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UserDataService {
  final AppDatabase database;

  UserDataService(this.database);
  // Hashing function for the password
  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
  Future<RegisterEntity?> getUserData(BuildContext context) async {
    RegisterEntity? user;
    try {
      String? username = await SharedPreferenceManager.getUsername();
      String? password = await SharedPreferenceManager.getPassword();
      String? hashedPassword = hashPassword(password!);

      if (username != null && password != null) {
        user = await database.registerDao.getUserByUsernameAndPassword(username, hashedPassword);
      }
    } catch (e) {
      print("Error loading user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load user data')));
    }
    return user;
  }
}
