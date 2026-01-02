import 'package:floor/floor.dart';

import '../entity/incomeEntity.dart';


@dao
abstract class IncomeDao {

  @Query("SELECT * FROM IncomeEntity ORDER BY date DESC")
  Future<List<IncomeEntity>> getAllIncome();

  @insert
  Future<void> insertIncome(IncomeEntity incomeEntity);

  @update
  Future<void> updateIncome(IncomeEntity incomeEntity);

  @delete
  Future<void> deleteIncome(IncomeEntity incomeEntity);

  @Query("SELECT * FROM IncomeEntity WHERE amount > :minAmount ORDER BY date DESC")
  Future<List<IncomeEntity>> getIncomeAboveAmount(double minAmount);

  @Query("SELECT * FROM IncomeEntity WHERE userId = :userId ORDER BY date DESC")
  Future<List<IncomeEntity>> findIncomesByUserId(int userId);

  @Query("SELECT amount FROM IncomeEntity WHERE userId = :userId")
  Future<List<double>> getAmountByUserId(int userId);

  @Query("""
  SELECT COALESCE(SUM(amount), 0) 
  FROM IncomeEntity 
  WHERE userId = :userId 
  AND strftime('%m', date) = :month 
  AND strftime('%Y', date) = :year
""")
  Future<double?> getTotalIncomeByUserIdAndMonth(int userId, String month, String year);

  @Query("SELECT COALESCE(SUM(amount), 0) FROM IncomeEntity WHERE userId = :userId")
  Future<double?> getTotalIncomeByUserId(int userId);


  @Query("""
    SELECT COALESCE(SUM(amount), 0)
    FROM IncomeEntity 
    WHERE userId = :userId 
    AND strftime('%m', date) = :month 
    AND strftime('%Y', date) = :year
  """)
  Future<double?> getMonthlyIncome(int userId, String month, String year);


}
