import 'package:floor/floor.dart';

@Entity()
class RegisterEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String userName; // Made non-nullable
  final String email; // Consider validation
  final String contact; // Consider validation
  final String password;

  RegisterEntity({
    this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.contact,
  });

}