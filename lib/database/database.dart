import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yccetpc/components/error_snackbar.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'attendance.db'),
      version: 2, // Increment the version number
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE failed_attendances(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          roundId INTEGER,
          attendanceId INTEGER
        );
        ''');

        db.execute('''
        CREATE TABLE Campus (
          CampusID INTEGER PRIMARY KEY AUTOINCREMENT,
          CampusName TEXT NOT NULL,
          Message TEXT,
          package TEXT,
          Date TEXT,
          Location TEXT
        );
        ''');

        db.execute('''
        CREATE TABLE Round (
          RoundID INTEGER PRIMARY KEY AUTOINCREMENT,
          CampusID INTEGER NOT NULL,
          RoundName TEXT NOT NULL,
          RoundDate TEXT NOT NULL,
          AttendanceID INTEGER,
          FOREIGN KEY (CampusID) REFERENCES Campus(CampusID)
        );
        ''');
         db.execute('''
        CREATE TABLE notifications(
          id TEXT PRIMARY KEY,
          title TEXT,
          body TEXT,
        );
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          // Add new columns to the notifications table
          db.execute('ALTER TABLE notifications ADD COLUMN screen TEXT;');
          db.execute('ALTER TABLE notifications ADD COLUMN screen_id INTEGER;');

          print('Old version : $oldVersion');
        }
      },
    );
  }

  Future<void> insertFailedAttendance(int roundId, int attendanceId) async {
    final db = await database;
    await db?.insert(
      'failed_attendances',
      {'roundId': roundId, 'attendanceId': attendanceId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFailedAttendances() async {
    final db = await database;
    return await db?.query('failed_attendances') ?? [];
  }

  Future<void> deleteFailedAttendance(int id) async {
    final db = await database;
    await db?.delete(
      'failed_attendances',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> insertCampus(context, int CampusID, String CampusName,
      String Message, String package, String date, String Location) async {
    try {
      final db = await database;
      await db?.insert(
        'Campus',
        {
          'CampusID': CampusID,
          'CampusName': CampusName,
          'Message': Message,
          "package": package,
          "Date": date,
          "Location": Location
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }

  Future<void> insertRound(context, int RoundID, int CampusID, String RoundName,
      String date, int AttendanceID) async {
    try {
      final db = await database;
      await db?.insert(
        'Round',
        {
          'CampusID': CampusID,
          'RoundID': RoundID,
          "RoundName": RoundName,
          "RoundDate": date,
          "AttendanceID": AttendanceID
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Something went wrong");
    }
  }

  Future<List<Map<String, dynamic>>> getCampuses() async {
    final db = await database;
    return await db?.query('Campus') ?? [];
  }

  Future<List<Map<String, dynamic>>> getRounds(int campusID) async {
    final db = await database;
    return await db
            ?.query('Round', where: 'CampusID = ?', whereArgs: [campusID]) ??
        [];
  }

  Future<void> deleteAllData(context) async {
    try {
      final db = await database;

      // Delete all rows from the failed_attendances table
      await db?.delete('failed_attendances');

      // Delete all rows from the Campus table
      await db?.delete('Campus');

      // Delete all rows from the Round table
      await db?.delete('Round');
    } catch (e) {
      InputComponent.showWarningSnackBar(context, "Error occured");
    }
  }

  Future<void> insertNotification(
      String? id, String? title, String? body,int? screen_id,String? screen) async {
    try {
      final db = await database;
      await db?.insert(
        'notifications',
        {'id': id, 'title': title, 'body': body,'screen':screen,'screen_id':screen_id},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("error occrued");
    }
  }
  Future<List<Map<String, dynamic>>> getNotifications() async {
  final db = await database;
  return await db?.query('notifications') ?? [];
}

}


