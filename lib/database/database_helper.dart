import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_app.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
    return db;
  }

  void _createTables(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE Income (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount REAL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Expense (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount REAL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');

    await db.rawInsert('''
      INSERT INTO User (username, password)
      VALUES ("user", "user")
    ''');
  }

  Future<bool> checkLogin(String username, String password) async {
    final dbClient = await db;
    final result = await dbClient!.query(
      'User',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  Future<int> insertIncome(DateTime date, double amount, String description) async {
    final dbClient = await db;
    return await dbClient!.insert(
      'Income',
      {
        'date': date.toIso8601String(),
        'amount': amount,
        'description': description,
      },
    );
  }

  Future<int> insertExpense(DateTime date, double amount, String description) async {
    final dbClient = await db;
    return await dbClient!.insert(
      'Expense',
      {
        'date': date.toIso8601String(),
        'amount': amount,
        'description': description,
      },
    );
  }

  Future<double> getTotalIncome() async {
    final dbClient = await db;
    final result = await dbClient!.rawQuery('SELECT SUM(amount) as Total FROM Income');

    // Mengambil nilai dari result['Total'] dan mengkonversi menjadi double
    double total = (result.isNotEmpty ? (result.first['Total'] ?? 0.0) : 0.0) as double;

    return total;
  }

  Future<double> getTotalExpense() async {
    final dbClient = await db;
    final result = await dbClient!.rawQuery('SELECT SUM(amount) as Total FROM Expense');

    double total = (result.isNotEmpty ? (result.first['Total'] ?? 0.0) : 0.0) as double;

    return total;
  }

  Future<List<Map<String, dynamic>>> getCashFlowData() async {
    final dbClient = await db;
    final incomeData = await dbClient!.query('Income', orderBy: 'date DESC');
    final expenseData = await dbClient.query('Expense', orderBy: 'date DESC');
    List<Map<String, dynamic>> cashFlowData = [];

    for (var incomeTransaction in incomeData) {
      cashFlowData.add({
        ...incomeTransaction,
        'type': 'Income',
      });
    }

    for (var expenseTransaction in expenseData) {
      cashFlowData.add({
        ...expenseTransaction,
        'type': 'Expense',
      });
    }

    return cashFlowData;
  }

  Future<bool> checkCurrentPassword(String currentPassword) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> results = await dbClient!.query(
      'user',
      where: 'password = ?',
      whereArgs: [currentPassword],
    );

    return results.isNotEmpty;
  }

  Future<void> updatePassword(String newPassword) async {
    final dbClient = await db;
    await dbClient!.update(
      'user',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: ['user'],
    );
  }


}


