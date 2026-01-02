import 'dart:async';
import 'package:floor/floor.dart';
import 'package:expense_tracker/floorDatabase/DAO/expensesDao.dart';
import 'package:expense_tracker/floorDatabase/DAO/goalDao.dart';
import 'package:expense_tracker/floorDatabase/entity/expensesEntity.dart';
import 'package:expense_tracker/floorDatabase/entity/goalEntity.dart';
import 'package:expense_tracker/floorDatabase/entity/incomeEntity.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import '../DAO/incomeDao.dart';
import '../DAO/registerDao.dart';

part 'database.g.dart';

@Database(version: 3, entities: [IncomeEntity, RegisterEntity, ExpensesEntity, GoalEntity])
abstract class AppDatabase extends FloorDatabase {
  IncomeDao get incomeDao;
  RegisterDao get registerDao;
  ExpensesDao get expensesDao;
  GoalDao get goalDao;
}

// Migration from version 1 to version 2
final migration1to2 = Migration(1, 2, (database) async {
  // Update IncomeEntity schema by adding new columns
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN recurringIncome INTEGER DEFAULT 0');
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN createdAt TEXT');
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN updatedAt TEXT');
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN note TEXT');
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN paymentMethod TEXT');
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN taxDeducted TEXT');
  await database.execute('ALTER TABLE IncomeEntity ADD COLUMN source TEXT');
});

// Migration from version 2 to version 3
final migration2to3 = Migration(2, 3, (database) async {
  // Add new columns to GoalEntity
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN targetAmount REAL');
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN savedAmount REAL');
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN goalName TEXT');
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN createdDate TEXT');
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN dueDate TEXT');
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN goalDescription TEXT');
  await database.execute('ALTER TABLE GoalEntity ADD COLUMN achievedGoal INTEGER DEFAULT 0');
});

