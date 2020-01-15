import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wallet/db/base_db_provider.dart';
import 'package:wallet/db/model/address.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';

class AddressDbProvider extends BaseDbProvider {
  ///表名
  final String name = 'address';

  final String columnName = "name";
  final String columnAddress = "address";

  static final AddressDbProvider addressDbProvider =
      AddressDbProvider._internal();
  factory AddressDbProvider() {
    return addressDbProvider;
  }

  AddressDbProvider._internal();

  @override
  tableName() {
    return name;
  }

  void createAddress() {
    prepare(name, createTableString());
  }

  @override
  createTableString() {
    return '''
        create table $name ($columnAddress string primary key,$columnName text not null)
      ''';
  }

  ///查询数据库
  Future _getAddressProvider(Database db, String walletName) async {
    List<Map<String, dynamic>> maps = await db
        .rawQuery("select * from $name where $columnName = '$walletName'");
    return maps;
  }

  ///通过地址查询地址数据
  Future _getAddressProviderWithAddress(Database db, String address) async {
    List<Map<String, dynamic>> maps = await db
        .rawQuery("select * from $name where $columnAddress = '$address'");
    return maps;
  }

  ///插入到数据库
  Future insert(Address model) async {
    print('insert model $model');
    Database db = await getDataBase();
    Address address = await getAddressWithAddress(model.address);
    if(address != null){
      return '';
    }
    return await db.rawInsert(
        "insert into $name ($columnName,$columnAddress) values (?,?)",
        [
          model.name,
          model.address,
        ]);
  }

  ///更新数据库
  Future<void> update(Address model) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnAddress = ?"
        "where $columnAddress= ?",
        [
          model.name,
          model.address,
        ]);
  }

  ///获取地址数据
  Future<Address> getWallet(String addressName) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await _getAddressProvider(db, addressName);
    if (maps.length > 0) {
      return Address.fromJson(maps[0]);
    }
    return null;
  }

  ///通过地址获取地址数据
  Future<Address> getAddressWithAddress(String address) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await _getAddressProviderWithAddress(db, address);
    if (maps.length > 0) {
      return Address.fromJson(maps[0]);
    }
    return null;
  }

  ///获取所有地址
  Future<List<Address>> getAddresses() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name");
    List<Address> addresses = List();
    for (Map<String, dynamic> map in maps) {
      addresses.add(Address.fromJson(map));
    }
    return addresses;
  }

  Future<Address> getFirstAddress() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name");
    if (maps.length > 0) {
      return Address.fromJson(maps[0]);
    }
    return null;
  }

  ///获取地址数量
  Future<int> getAddressCount() async {
    Database db = await getDataBase();
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $name'));
  }

  ///检查重复 true 不重复  false 重复
  Future<bool> checkRepetition(String addressValue) async {
    Address address = await getAddressWithAddress(addressValue);
    return address == null;
  }
}
