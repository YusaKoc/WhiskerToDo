import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final String databaseName = "todolist.db";

  static Future<Database> databaseAccess() async {

    String databasePath = join(await getDatabasesPath(),databaseName);

    if(await databaseExists(databasePath)){
      print("database exist");
    }else{
      ByteData data = await rootBundle.load("veritabani/$databaseName");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes,data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes,flush: true);
      print("database copied");
    }
    return openDatabase(databasePath);
  }


}