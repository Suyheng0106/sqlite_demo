import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _db;

  static Future<Database> get dbObject async {
    if (_db != null) {
      return _db!;
    } else {
      return _db = await initDB();
    }
  }

  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, "student6.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE "student" (
            "id"	INTEGER,
            "first_name"	TEXT,
            "last_name"	TEXT,
            "gender" TEXT,
            "dob" TEXT,
            "profile" TEXT,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
        ''');
      },
    );
  }

  static Future insertStudent(
    String firstName,
    String lastName,
    String gender,
    String dob,
    String profile,
  ) async {
    var db = await dbObject;

    return db.insert("student", {
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "dob": dob,
      "profile": profile,
    });
  }

  static Future updateStudent(
    String firstName,
    String lastName,
    String gender,
    String dob,
    String profile,
    int id,
  ) async {
    var db = await dbObject;

    return db.update("student", 
      {
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "dob": dob,
        "profile": profile,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getStudents() async {
    var db = await dbObject;
    return db.query("student");
  }

  static Future deleteStudent(int id) async {
    var db = await dbObject;

    return db.delete("student", where: "id = ?", whereArgs: [id]);
  }
}
