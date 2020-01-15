import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wallet/db/base_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';

class CircleDbProvider extends BaseDbProvider {
  ///表名
  final String name = 'circle';

  final String columnChainId = "chainId";
  final String columnName = "name";
  final String columnServerIp = "serverIp";
  final String columnServerPort = "serverPort";
  final String columnDesc = "desc";
  final String columnWalletAddress = "walletAddress";
  final String columnIsDefault = "isDefault";

  static final CircleDbProvider circleDbProvider = CircleDbProvider._internal();

  factory CircleDbProvider() {
    return circleDbProvider;
  }

  CircleDbProvider._internal();

  @override
  tableName() {
    return name;
  }

  void createCircle() {
    prepare(name, createTableString());
  }

  @override
  createTableString() {
    return '''create table $name ($columnChainId text not null,$columnName text not null,
        $columnServerIp text ,$columnServerPort int ,$columnDesc text not null,
        $columnWalletAddress text, $columnIsDefault int)''';
  }

  ///查询数据库 同时需要圈子id和地址
  Future _getCircleProvider(
      Database db, String chainId, String walletAddress) async {
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $name where $columnChainId = '$chainId' and $columnWalletAddress = '$walletAddress'");
    return maps;
  }

  ///插入到数据库
  Future insert(CircleDb model) async {
    print('insert model $model');
    Database db = await getDataBase();
    List<Map<String, dynamic>> circle =
        await _getCircleProvider(db, model.chainId, model.walletAddress);
    if (circle.length != 0) {
      return '';
    }
    return await db.rawInsert(
        "insert into $name "
        "($columnChainId,$columnName,$columnServerIp,$columnServerPort,"
        "$columnDesc,$columnWalletAddress,$columnIsDefault) "
        "values (?,?,?,?,?,?,?)",
        [
          model.chainId,
          model.name,
          model.serverIp,
          model.serverPort,
          model.desc,
          model.walletAddress,
          model.isDefault,
        ]);
  }

  ///更新数据库
  Future<void> update(CircleDb model) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnName = ?,$columnServerIp = ?$columnServerPort = ?"
        "$columnDesc = ?$columnWalletAddress = ?$columnIsDefault = ?"
        "where $columnChainId= ?",
        [
          model.name,
          model.serverIp,
          model.serverPort,
          model.desc,
          model.walletAddress,
          model.isDefault,
          model.chainId,
        ]);
  }

  ///获取地址数据
  Future<CircleDb> getCircle(String chainId, String walletAddress) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await _getCircleProvider(db, chainId, walletAddress);
    print('getCircle maps ${maps.length}');
    if (maps.length > 0) {
      return CircleDb.fromJson(maps[0]);
    }
    return null;
  }

  ///获取钱包内所有圈子
  Future<List<CircleDb>> getCircles(String walletAddress) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $name where $columnWalletAddress = '$walletAddress'");
    List<CircleDb> circles = List();
    for (Map<String, dynamic> map in maps) {
      circles.add(CircleDb.fromJson(map));
    }
    return circles;
  }

  Future<void> deleteCircle(CircleDb circleDb) async {
    Database database = await getDataBase();
    await database.rawDelete(
        "delete from $name where $columnChainId = ${circleDb.chainId} and $columnWalletAddress = ${circleDb.walletAddress}");
  }
}
