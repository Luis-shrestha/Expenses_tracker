import 'package:floor/floor.dart';
import '../entity/registerEntity.dart';

@dao
abstract class RegisterDao {
  @Query("SELECT * FROM RegisterEntity")
  Future<List<RegisterEntity>> getAllUsers();

  @insert
  Future<void> insertUser(RegisterEntity registerEntity);

  @update
  Future<void> updateUser(RegisterEntity registerEntity);

  @delete
  Future<void> deleteUser(RegisterEntity registerEntity);

  // Method to fetch a user by username and hashed password
  @Query("SELECT * FROM RegisterEntity WHERE userName = :username AND password = :hashedPassword")
  Future<RegisterEntity?> getUserByUsernameAndPassword(String username, String hashedPassword);

}