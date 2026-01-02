// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  IncomeDao? _incomeDaoInstance;

  RegisterDao? _registerDaoInstance;

  ExpensesDao? _expensesDaoInstance;

  GoalDao? _goalDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `IncomeEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `amount` REAL NOT NULL, `category` TEXT NOT NULL, `date` TEXT NOT NULL, `recurringIncome` INTEGER NOT NULL, `note` TEXT NOT NULL, `paymentMethod` TEXT NOT NULL, `taxDeducted` REAL NOT NULL, `source` TEXT NOT NULL, `userId` INTEGER NOT NULL, `createdAt` TEXT NOT NULL, `updatedAt` TEXT NOT NULL, FOREIGN KEY (`userId`) REFERENCES `RegisterEntity` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RegisterEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userName` TEXT NOT NULL, `email` TEXT NOT NULL, `contact` TEXT NOT NULL, `password` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ExpensesEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `amount` REAL NOT NULL, `category` TEXT, `date` TEXT, `userId` INTEGER NOT NULL, `paymentMethod` TEXT, `description` TEXT, `receiptImagePath` TEXT, `isRecurring` INTEGER, `tags` TEXT, FOREIGN KEY (`userId`) REFERENCES `RegisterEntity` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `GoalEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `targetAmount` REAL NOT NULL, `savedAmount` REAL NOT NULL, `goalName` TEXT NOT NULL, `createdDate` TEXT NOT NULL, `dueDate` TEXT NOT NULL, `goalDescription` TEXT NOT NULL, `achievedGoal` INTEGER, `userId` INTEGER NOT NULL, FOREIGN KEY (`userId`) REFERENCES `RegisterEntity` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  IncomeDao get incomeDao {
    return _incomeDaoInstance ??= _$IncomeDao(database, changeListener);
  }

  @override
  RegisterDao get registerDao {
    return _registerDaoInstance ??= _$RegisterDao(database, changeListener);
  }

  @override
  ExpensesDao get expensesDao {
    return _expensesDaoInstance ??= _$ExpensesDao(database, changeListener);
  }

  @override
  GoalDao get goalDao {
    return _goalDaoInstance ??= _$GoalDao(database, changeListener);
  }
}

class _$IncomeDao extends IncomeDao {
  _$IncomeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _incomeEntityInsertionAdapter = InsertionAdapter(
            database,
            'IncomeEntity',
            (IncomeEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date,
                  'recurringIncome': item.recurringIncome ? 1 : 0,
                  'note': item.note,
                  'paymentMethod': item.paymentMethod,
                  'taxDeducted': item.taxDeducted,
                  'source': item.source,
                  'userId': item.userId,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _incomeEntityUpdateAdapter = UpdateAdapter(
            database,
            'IncomeEntity',
            ['id'],
            (IncomeEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date,
                  'recurringIncome': item.recurringIncome ? 1 : 0,
                  'note': item.note,
                  'paymentMethod': item.paymentMethod,
                  'taxDeducted': item.taxDeducted,
                  'source': item.source,
                  'userId': item.userId,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                }),
        _incomeEntityDeletionAdapter = DeletionAdapter(
            database,
            'IncomeEntity',
            ['id'],
            (IncomeEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date,
                  'recurringIncome': item.recurringIncome ? 1 : 0,
                  'note': item.note,
                  'paymentMethod': item.paymentMethod,
                  'taxDeducted': item.taxDeducted,
                  'source': item.source,
                  'userId': item.userId,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<IncomeEntity> _incomeEntityInsertionAdapter;

  final UpdateAdapter<IncomeEntity> _incomeEntityUpdateAdapter;

  final DeletionAdapter<IncomeEntity> _incomeEntityDeletionAdapter;

  @override
  Future<List<IncomeEntity>> getAllIncome() async {
    return _queryAdapter.queryList(
        'SELECT * FROM IncomeEntity ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => IncomeEntity(
            id: row['id'] as int?,
            amount: row['amount'] as double,
            category: row['category'] as String,
            date: row['date'] as String,
            userId: row['userId'] as int,
            recurringIncome: (row['recurringIncome'] as int) != 0,
            note: row['note'] as String,
            paymentMethod: row['paymentMethod'] as String,
            taxDeducted: row['taxDeducted'] as double,
            source: row['source'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String));
  }

  @override
  Future<List<IncomeEntity>> getIncomeAboveAmount(double minAmount) async {
    return _queryAdapter.queryList(
        'SELECT * FROM IncomeEntity WHERE amount > ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => IncomeEntity(
            id: row['id'] as int?,
            amount: row['amount'] as double,
            category: row['category'] as String,
            date: row['date'] as String,
            userId: row['userId'] as int,
            recurringIncome: (row['recurringIncome'] as int) != 0,
            note: row['note'] as String,
            paymentMethod: row['paymentMethod'] as String,
            taxDeducted: row['taxDeducted'] as double,
            source: row['source'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String),
        arguments: [minAmount]);
  }

  @override
  Future<List<IncomeEntity>> findIncomesByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM IncomeEntity WHERE userId = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => IncomeEntity(
            id: row['id'] as int?,
            amount: row['amount'] as double,
            category: row['category'] as String,
            date: row['date'] as String,
            userId: row['userId'] as int,
            recurringIncome: (row['recurringIncome'] as int) != 0,
            note: row['note'] as String,
            paymentMethod: row['paymentMethod'] as String,
            taxDeducted: row['taxDeducted'] as double,
            source: row['source'] as String,
            createdAt: row['createdAt'] as String,
            updatedAt: row['updatedAt'] as String),
        arguments: [userId]);
  }

  @override
  Future<List<double>> getAmountByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT amount FROM IncomeEntity WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<double?> getTotalIncomeByUserIdAndMonth(
    int userId,
    String month,
    String year,
  ) async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(amount), 0)    FROM IncomeEntity    WHERE userId = ?1    AND strftime(\'%m\', date) = ?2    AND strftime(\'%Y\', date) = ?3',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId, month, year]);
  }

  @override
  Future<double?> getTotalIncomeByUserId(int userId) async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(amount), 0) FROM IncomeEntity WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<double?> getMonthlyIncome(
    int userId,
    String month,
    String year,
  ) async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(amount), 0)     FROM IncomeEntity      WHERE userId = ?1      AND strftime(\'%m\', date) = ?2      AND strftime(\'%Y\', date) = ?3',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId, month, year]);
  }

  @override
  Future<void> insertIncome(IncomeEntity incomeEntity) async {
    await _incomeEntityInsertionAdapter.insert(
        incomeEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateIncome(IncomeEntity incomeEntity) async {
    await _incomeEntityUpdateAdapter.update(
        incomeEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteIncome(IncomeEntity incomeEntity) async {
    await _incomeEntityDeletionAdapter.delete(incomeEntity);
  }
}

class _$RegisterDao extends RegisterDao {
  _$RegisterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _registerEntityInsertionAdapter = InsertionAdapter(
            database,
            'RegisterEntity',
            (RegisterEntity item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'email': item.email,
                  'contact': item.contact,
                  'password': item.password
                }),
        _registerEntityUpdateAdapter = UpdateAdapter(
            database,
            'RegisterEntity',
            ['id'],
            (RegisterEntity item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'email': item.email,
                  'contact': item.contact,
                  'password': item.password
                }),
        _registerEntityDeletionAdapter = DeletionAdapter(
            database,
            'RegisterEntity',
            ['id'],
            (RegisterEntity item) => <String, Object?>{
                  'id': item.id,
                  'userName': item.userName,
                  'email': item.email,
                  'contact': item.contact,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RegisterEntity> _registerEntityInsertionAdapter;

  final UpdateAdapter<RegisterEntity> _registerEntityUpdateAdapter;

  final DeletionAdapter<RegisterEntity> _registerEntityDeletionAdapter;

  @override
  Future<List<RegisterEntity>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM RegisterEntity',
        mapper: (Map<String, Object?> row) => RegisterEntity(
            id: row['id'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            contact: row['contact'] as String));
  }

  @override
  Future<RegisterEntity?> getUserByUsernameAndPassword(
    String username,
    String hashedPassword,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM RegisterEntity WHERE userName = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => RegisterEntity(
            id: row['id'] as int?,
            userName: row['userName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            contact: row['contact'] as String),
        arguments: [username, hashedPassword]);
  }

  @override
  Future<void> insertUser(RegisterEntity registerEntity) async {
    await _registerEntityInsertionAdapter.insert(
        registerEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(RegisterEntity registerEntity) async {
    await _registerEntityUpdateAdapter.update(
        registerEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(RegisterEntity registerEntity) async {
    await _registerEntityDeletionAdapter.delete(registerEntity);
  }
}

class _$ExpensesDao extends ExpensesDao {
  _$ExpensesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _expensesEntityInsertionAdapter = InsertionAdapter(
            database,
            'ExpensesEntity',
            (ExpensesEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date,
                  'userId': item.userId,
                  'paymentMethod': item.paymentMethod,
                  'description': item.description,
                  'receiptImagePath': item.receiptImagePath,
                  'isRecurring': item.isRecurring == null
                      ? null
                      : (item.isRecurring! ? 1 : 0),
                  'tags': item.tags
                }),
        _expensesEntityUpdateAdapter = UpdateAdapter(
            database,
            'ExpensesEntity',
            ['id'],
            (ExpensesEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date,
                  'userId': item.userId,
                  'paymentMethod': item.paymentMethod,
                  'description': item.description,
                  'receiptImagePath': item.receiptImagePath,
                  'isRecurring': item.isRecurring == null
                      ? null
                      : (item.isRecurring! ? 1 : 0),
                  'tags': item.tags
                }),
        _expensesEntityDeletionAdapter = DeletionAdapter(
            database,
            'ExpensesEntity',
            ['id'],
            (ExpensesEntity item) => <String, Object?>{
                  'id': item.id,
                  'amount': item.amount,
                  'category': item.category,
                  'date': item.date,
                  'userId': item.userId,
                  'paymentMethod': item.paymentMethod,
                  'description': item.description,
                  'receiptImagePath': item.receiptImagePath,
                  'isRecurring': item.isRecurring == null
                      ? null
                      : (item.isRecurring! ? 1 : 0),
                  'tags': item.tags
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExpensesEntity> _expensesEntityInsertionAdapter;

  final UpdateAdapter<ExpensesEntity> _expensesEntityUpdateAdapter;

  final DeletionAdapter<ExpensesEntity> _expensesEntityDeletionAdapter;

  @override
  Future<List<ExpensesEntity>> getAllExpenses() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ExpensesEntity ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpensesEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as double,
            date: row['date'] as String?,
            userId: row['userId'] as int,
            paymentMethod: row['paymentMethod'] as String?,
            description: row['description'] as String?,
            receiptImagePath: row['receiptImagePath'] as String?,
            isRecurring: row['isRecurring'] == null
                ? null
                : (row['isRecurring'] as int) != 0,
            tags: row['tags'] as String?));
  }

  @override
  Future<List<ExpensesEntity>> getExpensesAboveAmount(double minAmount) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ExpensesEntity WHERE amount > ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpensesEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as double,
            date: row['date'] as String?,
            userId: row['userId'] as int,
            paymentMethod: row['paymentMethod'] as String?,
            description: row['description'] as String?,
            receiptImagePath: row['receiptImagePath'] as String?,
            isRecurring: row['isRecurring'] == null
                ? null
                : (row['isRecurring'] as int) != 0,
            tags: row['tags'] as String?),
        arguments: [minAmount]);
  }

  @override
  Future<List<ExpensesEntity>> findExpensesByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ExpensesEntity WHERE userId = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpensesEntity(
            id: row['id'] as int?,
            category: row['category'] as String?,
            amount: row['amount'] as double,
            date: row['date'] as String?,
            userId: row['userId'] as int,
            paymentMethod: row['paymentMethod'] as String?,
            description: row['description'] as String?,
            receiptImagePath: row['receiptImagePath'] as String?,
            isRecurring: row['isRecurring'] == null
                ? null
                : (row['isRecurring'] as int) != 0,
            tags: row['tags'] as String?),
        arguments: [userId]);
  }

  @override
  Future<List<double>> getAmountByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT amount FROM ExpensesEntity WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<double?> getTotalExpensesByUserId(int userId) async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(amount), 0) FROM ExpensesEntity WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId]);
  }

  @override
  Future<double?> getTotalExpensesByUserIdAndMonth(
    int userId,
    String month,
    String year,
  ) async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(amount), 0)    FROM ExpensesEntity    WHERE userId = ?1    AND strftime(\'%m\', date) = ?2    AND strftime(\'%Y\', date) = ?3',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId, month, year]);
  }

  @override
  Future<double?> getMonthlyExpenses(
    int userId,
    String month,
    String year,
  ) async {
    return _queryAdapter.query(
        'SELECT COALESCE(SUM(amount), 0)     FROM ExpensesEntity      WHERE userId = ?1      AND strftime(\'%m\', date) = ?2      AND strftime(\'%Y\', date) = ?3',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [userId, month, year]);
  }

  @override
  Future<List<ExpensesEntity>> filterExpensesByPayment(
    String method,
    int userId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ExpensesEntity      WHERE paymentMethod = ?1      AND userId = ?2      ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => ExpensesEntity(id: row['id'] as int?, category: row['category'] as String?, amount: row['amount'] as double, date: row['date'] as String?, userId: row['userId'] as int, paymentMethod: row['paymentMethod'] as String?, description: row['description'] as String?, receiptImagePath: row['receiptImagePath'] as String?, isRecurring: row['isRecurring'] == null ? null : (row['isRecurring'] as int) != 0, tags: row['tags'] as String?),
        arguments: [method, userId]);
  }

  @override
  Future<void> insertExpenses(ExpensesEntity expensesEntity) async {
    await _expensesEntityInsertionAdapter.insert(
        expensesEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpenses(ExpensesEntity expensesEntity) async {
    await _expensesEntityUpdateAdapter.update(
        expensesEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExpenses(ExpensesEntity expensesEntity) async {
    await _expensesEntityDeletionAdapter.delete(expensesEntity);
  }
}

class _$GoalDao extends GoalDao {
  _$GoalDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _goalEntityInsertionAdapter = InsertionAdapter(
            database,
            'GoalEntity',
            (GoalEntity item) => <String, Object?>{
                  'id': item.id,
                  'targetAmount': item.targetAmount,
                  'savedAmount': item.savedAmount,
                  'goalName': item.goalName,
                  'createdDate': item.createdDate,
                  'dueDate': item.dueDate,
                  'goalDescription': item.goalDescription,
                  'achievedGoal': item.achievedGoal == null
                      ? null
                      : (item.achievedGoal! ? 1 : 0),
                  'userId': item.userId
                }),
        _goalEntityUpdateAdapter = UpdateAdapter(
            database,
            'GoalEntity',
            ['id'],
            (GoalEntity item) => <String, Object?>{
                  'id': item.id,
                  'targetAmount': item.targetAmount,
                  'savedAmount': item.savedAmount,
                  'goalName': item.goalName,
                  'createdDate': item.createdDate,
                  'dueDate': item.dueDate,
                  'goalDescription': item.goalDescription,
                  'achievedGoal': item.achievedGoal == null
                      ? null
                      : (item.achievedGoal! ? 1 : 0),
                  'userId': item.userId
                }),
        _goalEntityDeletionAdapter = DeletionAdapter(
            database,
            'GoalEntity',
            ['id'],
            (GoalEntity item) => <String, Object?>{
                  'id': item.id,
                  'targetAmount': item.targetAmount,
                  'savedAmount': item.savedAmount,
                  'goalName': item.goalName,
                  'createdDate': item.createdDate,
                  'dueDate': item.dueDate,
                  'goalDescription': item.goalDescription,
                  'achievedGoal': item.achievedGoal == null
                      ? null
                      : (item.achievedGoal! ? 1 : 0),
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<GoalEntity> _goalEntityInsertionAdapter;

  final UpdateAdapter<GoalEntity> _goalEntityUpdateAdapter;

  final DeletionAdapter<GoalEntity> _goalEntityDeletionAdapter;

  @override
  Future<List<GoalEntity>> getAllGoal() async {
    return _queryAdapter.queryList('SELECT * FROM GoalEntity',
        mapper: (Map<String, Object?> row) => GoalEntity(
            id: row['id'] as int?,
            goalName: row['goalName'] as String,
            targetAmount: row['targetAmount'] as double,
            savedAmount: row['savedAmount'] as double,
            createdDate: row['createdDate'] as String,
            dueDate: row['dueDate'] as String,
            goalDescription: row['goalDescription'] as String,
            userId: row['userId'] as int,
            achievedGoal: row['achievedGoal'] == null
                ? null
                : (row['achievedGoal'] as int) != 0));
  }

  @override
  Future<List<GoalEntity>> getGoalAboveAmount(double minAmount) async {
    return _queryAdapter.queryList(
        'SELECT * FROM GoalEntity WHERE amount > ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => GoalEntity(
            id: row['id'] as int?,
            goalName: row['goalName'] as String,
            targetAmount: row['targetAmount'] as double,
            savedAmount: row['savedAmount'] as double,
            createdDate: row['createdDate'] as String,
            dueDate: row['dueDate'] as String,
            goalDescription: row['goalDescription'] as String,
            userId: row['userId'] as int,
            achievedGoal: row['achievedGoal'] == null
                ? null
                : (row['achievedGoal'] as int) != 0),
        arguments: [minAmount]);
  }

  @override
  Future<List<GoalEntity>> findGoalsByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM GoalEntity WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => GoalEntity(
            id: row['id'] as int?,
            goalName: row['goalName'] as String,
            targetAmount: row['targetAmount'] as double,
            savedAmount: row['savedAmount'] as double,
            createdDate: row['createdDate'] as String,
            dueDate: row['dueDate'] as String,
            goalDescription: row['goalDescription'] as String,
            userId: row['userId'] as int,
            achievedGoal: row['achievedGoal'] == null
                ? null
                : (row['achievedGoal'] as int) != 0),
        arguments: [userId]);
  }

  @override
  Future<List<GoalEntity>> getGoalsMonthlyByUserId(
    int userId,
    String monthPattern,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM GoalEntity        WHERE userId = ?1        AND createdDate LIKE ?2',
        mapper: (Map<String, Object?> row) => GoalEntity(id: row['id'] as int?, goalName: row['goalName'] as String, targetAmount: row['targetAmount'] as double, savedAmount: row['savedAmount'] as double, createdDate: row['createdDate'] as String, dueDate: row['dueDate'] as String, goalDescription: row['goalDescription'] as String, userId: row['userId'] as int, achievedGoal: row['achievedGoal'] == null ? null : (row['achievedGoal'] as int) != 0),
        arguments: [userId, monthPattern]);
  }

  @override
  Future<List<GoalEntity>> getAchievedGoalsByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM GoalEntity        WHERE userId = ?1        AND achievedGoal = 1',
        mapper: (Map<String, Object?> row) => GoalEntity(id: row['id'] as int?, goalName: row['goalName'] as String, targetAmount: row['targetAmount'] as double, savedAmount: row['savedAmount'] as double, createdDate: row['createdDate'] as String, dueDate: row['dueDate'] as String, goalDescription: row['goalDescription'] as String, userId: row['userId'] as int, achievedGoal: row['achievedGoal'] == null ? null : (row['achievedGoal'] as int) != 0),
        arguments: [userId]);
  }

  @override
  Future<void> insertGoal(GoalEntity goalEntity) async {
    await _goalEntityInsertionAdapter.insert(
        goalEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGoal(GoalEntity goalEntity) async {
    await _goalEntityUpdateAdapter.update(goalEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGoal(GoalEntity goalEntity) async {
    await _goalEntityDeletionAdapter.delete(goalEntity);
  }
}
