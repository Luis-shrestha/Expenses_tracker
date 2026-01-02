import 'package:floor/floor.dart';
import '../entity/expensesEntity.dart';



@dao
abstract class ExpensesDao {

  @Query("SELECT * FROM ExpensesEntity ORDER BY date DESC")
  Future<List<ExpensesEntity>> getAllExpenses();

  @insert
  Future<void> insertExpenses(ExpensesEntity expensesEntity);

  @update
  Future<void> updateExpenses(ExpensesEntity expensesEntity);

  @delete
  Future<void> deleteExpenses(ExpensesEntity expensesEntity);

  @Query("SELECT * FROM ExpensesEntity WHERE amount > :minAmount ORDER BY date DESC")
  Future<List<ExpensesEntity>> getExpensesAboveAmount(double minAmount);

  @Query("SELECT * FROM ExpensesEntity WHERE userId = :userId ORDER BY date DESC")
  Future<List<ExpensesEntity>> findExpensesByUserId(int userId);

  @Query("SELECT amount FROM ExpensesEntity WHERE userId = :userId")
  Future<List<double>> getAmountByUserId(int userId);

  @Query("SELECT COALESCE(SUM(amount), 0) FROM ExpensesEntity WHERE userId = :userId")
  Future<double?> getTotalExpensesByUserId(int userId);

  @Query("""
  SELECT COALESCE(SUM(amount), 0) 
  FROM ExpensesEntity 
  WHERE userId = :userId 
  AND strftime('%m', date) = :month 
  AND strftime('%Y', date) = :year
""")
  Future<double?> getTotalExpensesByUserIdAndMonth(int userId, String month, String year);


  @Query("""
    SELECT COALESCE(SUM(amount), 0)
    FROM ExpensesEntity 
    WHERE userId = :userId 
    AND strftime('%m', date) = :month 
    AND strftime('%Y', date) = :year
  """)
  Future<double?> getMonthlyExpenses(int userId, String month, String year);


  @Query("""
    SELECT * FROM ExpensesEntity 
    WHERE paymentMethod = :method 
    AND userId = :userId 
    ORDER BY date DESC
  """)
  Future<List<ExpensesEntity>> filterExpensesByPayment(String method, int userId);

}


