import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:sqlpractice2/model/contact_model.dart';

class MyDBHelper{

  static Future<Database> initDB() async {

    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'contact.db');
    return await openDatabase(path,version: 1,onCreate: _onCreate);
  }
  static Future _onCreate(Database db,int version) async {
    await db.execute(
        'CREATE TABLE contact (id INTEGER PRIMARY KEY AUTOINCREMENT, contactName TEXT, contactNumber Text)');
  }
  static Future<int> createContact(ContactModel contact) async
  {
    Database db =await MyDBHelper.initDB();
    db.insert('contact', contact.toMap());
    return 1;

  }
  static Future<List<ContactModel>> readAllContact() async
  {
    Database db = await MyDBHelper.initDB();
    var contact  = await db.query('contact');
    List <ContactModel> contactList = contact.map((e)=>ContactModel.fromMap(e)).toList();
    return contactList;
  }
  static Future<void> updateContact(ContactModel contact)
  async {
    Database db = await MyDBHelper.initDB();
    db.update('contact', contact.toMap(),where: 'id =?',whereArgs: [contact.id]);
  }
  static Future<void> deleteContact (ContactModel contact) async {
    Database db = await MyDBHelper.initDB();
    db.delete('contact',where:'id=?',whereArgs: [contact.id]);
  }
  
}