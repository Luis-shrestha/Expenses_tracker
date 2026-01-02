import 'package:floor/floor.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['userId'],
      parentColumns: ['id'],
      entity: RegisterEntity,
    ),
  ],
)
class GoalEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final double targetAmount;
  final double savedAmount;
  final String goalName;
  final String createdDate;
  final String dueDate;
  final String goalDescription;
  final bool? achievedGoal;

  @ColumnInfo(name: 'userId')
  final int userId;

  GoalEntity({
    this.id,
    required this.goalName,
    required this.targetAmount,
    required this.savedAmount,
    required this.createdDate,
    required this.dueDate,
    required this.goalDescription,
    required this.userId,
    this.achievedGoal = false,
  });
}
