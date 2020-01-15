import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/db/address_db_provider.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/wallet_db_provider.dart';

class SqlManager {
  static const _VERSION = 1;

  static const _NAME = "wallet.db";

  static Database _database;

  ///初始化
  static init() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});

    ///创建钱包表
    WalletDbProvider walletDbProvider = WalletDbProvider();
    walletDbProvider.createWallet();

    ///创建地址表
    AddressDbProvider addressDbProvider = AddressDbProvider();
    addressDbProvider.createAddress();

    ///创建圈子表
    CircleDbProvider circleDbProvider = CircleDbProvider();
    circleDbProvider.createCircle();
  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}
