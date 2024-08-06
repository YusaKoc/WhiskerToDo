import 'package:whiskertodolist/databasehelper/databasehelper.dart';

import 'classes.dart';

class Todaydao {
  Future<List<today>> allToday() async{
    var db = await DatabaseHelper.databaseAccess();
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM today");
    return List.generate(maps.length, (i){
      var line = maps[i];
      return today(line["mesaj_id"], line["mesajtoday"]);

    });

  }
  Future<void> addMessageToday(String mesajtoday) async {
    var db = await DatabaseHelper.databaseAccess();

    var informations = Map<String,dynamic>();
    informations["mesajtoday"] = mesajtoday;

    await db.insert("today", informations);

  }

  Future<void> messageEditor(int mesaj_id, String newMessage) async {
    var db = await DatabaseHelper.databaseAccess();

    var informations = Map<String, dynamic>();
    informations["mesajtoday"] = newMessage;

    await db.update(
      "today",
      informations,
      where: "mesaj_id = ?",
      whereArgs: [mesaj_id],
    );
  }


  Future<void> deleteMessageToday(int mesaj_id,) async {
    var db = await DatabaseHelper.databaseAccess();

    await db.delete("today",where: "mesaj_id=?",whereArgs: [mesaj_id] );

  }

}

class Monthdao {
  Future<List<monthly>> allMonth() async{
    var db = await DatabaseHelper.databaseAccess();
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM monthly");
    return List.generate(maps.length, (k){
      var line = maps[k];
      return monthly(line["monthly_id"], line["monthlymesaj"]);

    });

  }
  Future<void> addMessageMonth(String monthlymesaj) async {
    var db = await DatabaseHelper.databaseAccess();

    var informations = Map<String,dynamic>();
    informations["monthlymesaj"] = monthlymesaj;

    await db.insert("monthly", informations);

  }

  Future<void> messageEditor(int monthly_id, String newMessage) async {
    var db = await DatabaseHelper.databaseAccess();

    var informations = Map<String, dynamic>();
    informations["monthlymesaj"] = newMessage;

    await db.update(
      "monthly",
      informations,
      where: "monthly_id = ?",
      whereArgs: [monthly_id],
    );
  }


  Future<void> deleteMessageMonthly(int monthly_id,) async {
    var db = await DatabaseHelper.databaseAccess();

    await db.delete("monthly",where: "monthly_id=?",whereArgs: [monthly_id] );

  }

}

class Yeardao {
  Future<List<yearly>> allYear() async{
    var db = await DatabaseHelper.databaseAccess();
    List<Map<String,dynamic>> maps = await db.rawQuery("SELECT * FROM yearly");
    return List.generate(maps.length, (p){
      var line = maps[p];
      return yearly(line["yearly_id"], line["yearly_mesaj"]);

    });

  }
  Future<void> addMessageYear(String yearly_mesaj) async {
    var db = await DatabaseHelper.databaseAccess();

    var informations = Map<String,dynamic>();
    informations["yearly_mesaj"] = yearly_mesaj;

    await db.insert("yearly", informations);

  }

  Future<void> messageEditor(int yearly_id, String newMessage) async {
    var db = await DatabaseHelper.databaseAccess();

    var informations = Map<String, dynamic>();
    informations["yearly_mesaj"] = newMessage;

    await db.update(
      "yearly",
      informations,
      where: "yearly_id = ?",
      whereArgs: [yearly_id],
    );
  }


  Future<void> deleteMessageYearly(int yearly_id,) async {
    var db = await DatabaseHelper.databaseAccess();

    await db.delete("yearly",where: "yearly_id=?",whereArgs: [yearly_id] );

  }

}