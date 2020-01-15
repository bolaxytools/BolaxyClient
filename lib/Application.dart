import 'package:fluro/fluro.dart';
import 'package:flutter/services.dart';
import 'package:wallet/db/sql_manager.dart';

class Application {
  static Router router;

  static void init() {

    initDB();

  }

  static void initDB(){
    SqlManager.init();
  }

  static void release(){
    print('release');
    SqlManager.close();
  }

}
