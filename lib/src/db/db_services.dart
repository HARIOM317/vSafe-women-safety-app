import 'package:sqflite/sqflite.dart';
import 'package:vsafe/src/model/contact_model.dart';

class DataBaseHelper {
  String contactTable = 'contact_table';
  String columnId = 'id';
  String columnContactName = 'name';
  String columnContactNumber = 'number';

  // named constructor
  DataBaseHelper._createInstance();

  // instance of the database
  static DataBaseHelper? _dataBaseHelper;

  // factory keyword allows the constructor to return some value
  factory DataBaseHelper() {
    _dataBaseHelper ??= DataBaseHelper._createInstance();
    return _dataBaseHelper!;
  }

  // initializing the database
  static Database? _database;
  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String directoryPath = await getDatabasesPath();
    String dbLocation = '${directoryPath}contact.db';

    var contactDatabase = await openDatabase(dbLocation, version: 1, onCreate: _createDBTable);
    return contactDatabase;
  }

  void _createDBTable(Database db, int newVersion) async {
    await db.execute(
      'CREATE TABLE $contactTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnContactName TEXT, $columnContactNumber TEXT)'
    );
  }

  // Fetch Operation: get contact object from db
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
    await db.rawQuery('SELECT * FROM $contactTable order by $columnId ASC');

    return result;
  }

  //Insert a contact object
  Future<int> insertContact(TContactModel contact) async {
    Database db = await database;
    var result = await db.insert(contactTable, contact.toMap());
    return result;
  }

  // update a contact object
  Future<int> updateContact(TContactModel contact) async {
    Database db = await database;
    var result = await db.update(contactTable, contact.toMap(),
        where: '$columnId = ?', whereArgs: [contact.id]);
    return result;
  }

  //delete a contact object
  Future<int> deleteContact(int id) async {
    Database db = await database;
    int result =
    await db.rawDelete('DELETE FROM $contactTable WHERE $columnId = $id');
    return result;
  }

  //get number of contact objects
  Future<int> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Contact List' [ List<Contact> ]
  Future<List<TContactModel>> getContactList() async {
    var contactMapList =
    await getContactMapList(); // Get 'Map List' from database
    int count = contactMapList.length; // Count the number of map entries in db table

    List<TContactModel> contactList = <TContactModel>[];
    // for loop to create a 'Contact List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(TContactModel.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }
}