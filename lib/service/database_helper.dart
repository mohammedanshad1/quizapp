// lib/models/database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'quiz_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answerChoicesId INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Choices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionId INTEGER NOT NULL,
        choice TEXT NOT NULL,
        isCorrect INTEGER NOT NULL,
        FOREIGN KEY (questionId) REFERENCES Questions (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Students(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        mobileNumber TEXT NOT NULL,
        loginPassword TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE StudentAnswers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        questionId INTEGER NOT NULL,
        choiceId INTEGER NOT NULL,
        FOREIGN KEY (studentId) REFERENCES Students (id),
        FOREIGN KEY (questionId) REFERENCES Questions (id),
        FOREIGN KEY (choiceId) REFERENCES Choices (id)
      )
    ''');
  }
}