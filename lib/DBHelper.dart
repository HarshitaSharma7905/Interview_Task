import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DBHelper {
  static final DBHelper instance =DBHelper._privateConstructor();
  static Database? _database;
  DBHelper._privateConstructor();
  //check database exist or not
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }
  //database init
  Future<Database> _initDatabase() async{

    String path = join(await getDatabasesPath(),'employee.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }
  //on create method to create database
  Future<void> _onCreate(Database db,int version) async{
    String sql='CREATE TABLE users(id INTEGER PRIMARY KEY, firstName TEXT ,lastName TEXT,email TEXT,avatar TEXT)';
    await db.execute(sql);
  }
  //  insert--------
  Future<int> insert(Map<String,dynamic> row)async{
    Database db=await instance.database;
    return await db.insert('users', row);
  }
  //to fetch---------
  Future<List<Map<String,dynamic>>> fetchData() async{
    Database db=await instance.database;
    return await db.query('users');
  }
  //update:---------
  Future<int> update(Map<String,dynamic> row) async{
    Database db=await instance.database;
    int id=row['id'];
    return await db.update('users', row,where: 'id=?',whereArgs: [id]);
  }
  //delete---------
  Future<int> delete(int id) async{
    Database db = await instance.database;
    return await db.delete('users',where: 'id=?',whereArgs: [id]);
  }
//

  Future<Map<String, dynamic>> getUserById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {}; // Return an empty map if user not found
    }
  }
}
