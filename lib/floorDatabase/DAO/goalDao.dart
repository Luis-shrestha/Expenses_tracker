import 'package:floor/floor.dart';
import 'package:expense_tracker/floorDatabase/entity/goalEntity.dart';

@dao
abstract class GoalDao {
  @Query("SELECT * FROM GoalEntity")
  Future<List<GoalEntity>> getAllGoal();

  @insert
  Future<void> insertGoal(GoalEntity goalEntity);

  @update
  Future<void> updateGoal(GoalEntity goalEntity);

  @delete
  Future<void> deleteGoal(GoalEntity goalEntity);

  @Query("SELECT * FROM GoalEntity WHERE amount > :minAmount ORDER BY date DESC")
  Future<List<GoalEntity>> getGoalAboveAmount(double minAmount);

  @Query('SELECT * FROM GoalEntity WHERE userId = :userId')
  Future<List<GoalEntity>> findGoalsByUserId(int userId);

  /// ✅ Get goals for a specific user by month (1–12)
  @Query("""
      SELECT * FROM GoalEntity 
      WHERE userId = :userId 
      AND createdDate LIKE :monthPattern
  """)
  Future<List<GoalEntity>> getGoalsMonthlyByUserId(int userId, String monthPattern);

  /// ✅ Get only achieved goals
  @Query("""
      SELECT * FROM GoalEntity 
      WHERE userId = :userId 
      AND achievedGoal = 1
  """)
  Future<List<GoalEntity>> getAchievedGoalsByUserId(int userId);
}

