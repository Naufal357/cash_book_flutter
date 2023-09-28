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
    // Tabel untuk pemasukan
    await db.execute('''
      CREATE TABLE Income (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount REAL,
        description TEXT
      )
    ''');

    // Tabel untuk pengeluaran
    await db.execute('''
      CREATE TABLE Expense (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        amount REAL,
        description TEXT
      )
    ''');

    // Tabel untuk menyimpan username dan password pengguna
    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');

    // Menambahkan pengguna default
    await db.rawInsert('''
      INSERT INTO User (username, password)
      VALUES ("user", "user")
    ''');
  }

  // Check Login
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

// Fungsi untuk menghitung total pemasukan
  Future<double> getTotalIncome() async {
    final dbClient = await db;
    final result = await dbClient!.rawQuery('SELECT SUM(amount) as Total FROM Income');

    // Mengambil nilai dari result['Total'] dan mengkonversi menjadi double
    double total = (result.isNotEmpty ? (result.first['Total'] ?? 0.0) : 0.0) as double;

    return total;
  }

// Fungsi untuk menghitung total pengeluaran
  Future<double> getTotalExpense() async {
    final dbClient = await db;
    final result = await dbClient!.rawQuery('SELECT SUM(amount) as Total FROM Expense');

    // Mengambil nilai dari result['Total'] dan mengkonversi menjadi double
    double total = (result.isNotEmpty ? (result.first['Total'] ?? 0.0) : 0.0) as double;

    return total;
  }

  Future<List<Map<String, dynamic>>> getCashFlowData() async {
    final dbClient = await db;
    final incomeData = await dbClient!.query('Income', orderBy: 'date DESC');
    final expenseData = await dbClient.query('Expense', orderBy: 'date DESC');
    List<Map<String, dynamic>> cashFlowData = [];

    // Menggabungkan data pemasukan dan pengeluaran menjadi satu list
    cashFlowData.addAll(incomeData);
    cashFlowData.addAll(expenseData);

    return cashFlowData;
  }

  // Fungsi untuk mengganti password pengguna
  Future<int> changePassword(String newPassword) async {
    final dbClient = await db;
    return await dbClient!.update(
      'User',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [1], // ID pengguna default
    );
  }
}


