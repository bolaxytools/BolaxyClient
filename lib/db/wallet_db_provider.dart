import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wallet/db/base_db_provider.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/utils/native_communication.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';

class WalletDbProvider extends BaseDbProvider {
  ///表名
  final String name = 'wallet';

  final String columnName = "name";
  final String columnPassword = "password";
  final String columnNotice = "notice";
  final String columnMnemonicWord = "mnemonicWord";
  final String privateKey = "privateKey";
  final String columnKeyStore = "keyStore";
  final String columnAddress = "address";
  final String publicKey = "publicKey";
  final String columnCircleChainId = "circleChainId";
  final String columnIsBackup = "isBackup";

//  WalletDbProvider();

  static final WalletDbProvider walletDbProvider =
      WalletDbProvider._internal(); //1
  factory WalletDbProvider() {
    //2
    return walletDbProvider;
  }

  WalletDbProvider._internal(); //3

  @override
  tableName() {
    return name;
  }

  void createWallet() {
    prepare(name, createTableString());
  }

  @override
  createTableString() {
    return '''
        create table $name (
        $columnName string primary key,$columnPassword text not null,
        $columnNotice text not null,$columnMnemonicWord text not null,$privateKey text not null,
        $columnKeyStore text not null,$columnAddress text not null,$publicKey text not null,
        $columnCircleChainId text not null,$columnIsBackup INTEGER)
      ''';
  }

  ///查询数据库
  Future _getWalletProvider(Database db, String walletName) async {
    List<Map<String, dynamic>> maps = await db
        .rawQuery("select * from $name where $columnName = '$walletName'");
    return maps;
  }

  ///通过地址查询钱包
  Future _getWalletProviderWithAddress(Database db, String address) async {
    List<Map<String, dynamic>> maps = await db
        .rawQuery("select * from $name where $columnAddress = '$address'");
    return maps;
  }

  ///插入到数据库
  Future insert(Wallet model) async {
    print('insert model ${model.name}');
    model = await model.generatePrivateKey();
    Database db = await getDataBase();
//    var walletProvider = await _getWalletProvider(db, model.name);
//    print('insert walletProvider $walletProvider');
//    if (walletProvider != null) {
//      ///删除数据
//      await db.delete(name, where: "$columnName = ?", whereArgs: [model.name]);
//    }
    print('insert rawInsert ${model.address}');
    return await db.rawInsert(
        "insert into $name ($columnName,$columnPassword,$columnNotice,$columnMnemonicWord,$privateKey,"
        "$columnKeyStore,$columnAddress,$publicKey,$columnCircleChainId,$columnIsBackup) "
        "values (?,?,?,?,?,?,?,?,?,?)",
        [
          model.name,
          model.password,
          model.notice,
          model.mnemonicWord,
          model.privateKey,
          model.keyStore,
          model.address,
          model.publicKey,
          model.circleChainId,
          model.isBackup,
        ]);
  }

//  Future<int> saveItem(Wallet wallet) async {
//    var dbClient = await getDataBase();
//    int res = await dbClient.insert("$tableName", wallet.toJson());
//    print(res.toString());
//    return res;
//  }

  ///更新数据库
  Future<void> update(Wallet model) async {
    print('update model.circleChainId ${model.circleChainId}');
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnPassword = ?,$columnNotice = ?,$columnMnemonicWord = ?,$privateKey = ?,"
        "$columnKeyStore = ?,$columnAddress = ?,$publicKey = ?,$columnCircleChainId = ? ,$columnIsBackup = ?"
        "where $columnName= ?",
        [
          model.password,
          model.notice,
          model.mnemonicWord,
          model.privateKey,
          model.keyStore,
          model.address,
          model.publicKey,
          model.circleChainId,
          model.isBackup,
          model.name,
        ]);
  }

  Future<void> delete(String walletName) async {
    Database db = await getDataBase();
    await db.delete(name, where: "$columnName = ?", whereArgs: [walletName]);
  }

  ///获取当前的钱包
  Future<Wallet> getCurrentWallet() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String walletAddress =
        sharedPreferences.getString(SharedPreferencesUtils.sp_current_wallet);
    return getWalletWithAddress(walletAddress);
  }

  ///获取钱包数据
  Future<Wallet> getWallet(String walletName) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await _getWalletProvider(db, walletName);
    if (maps.length > 0) {
      return Wallet.fromJson(maps[0]);
    }
    return null;
  }

  ///获取钱包数据
  Future<Wallet> getWalletWithKeyStore(String keyStore) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db
        .rawQuery("select * from $name where $columnKeyStore = '$keyStore'");
    if (maps.length > 0) {
      return Wallet.fromJson(maps[0]);
    }
    return null;
  }

  Future<Wallet> getWalletWithMnemonicWord(String mnemonicWord) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "select * from $name where $columnMnemonicWord = '$mnemonicWord'");
    if (maps.length > 0) {
      return Wallet.fromJson(maps[0]);
    }
    return null;
  }

  ///通过地址获取钱包数据
  Future<Wallet> getWalletWithAddress(String address) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await _getWalletProviderWithAddress(db, address);
    if (maps.length > 0) {
      return Wallet.fromJson(maps[0]);
    }
    return null;
  }

  ///获取所有钱包
  Future<List<Wallet>> getWallets() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name");
    List<Wallet> wallets = List();
    print('getWallets maps $maps');
    print('getWallets maps ${maps.length}');
    for (Map<String, dynamic> map in maps) {
      wallets.add(Wallet.fromJson(map));
    }
    return wallets;
  }

  Future<Wallet> getFirstWallet() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.rawQuery("select * from $name");
    if (maps.length > 0) {
      return Wallet.fromJson(maps[0]);
    }
    return null;
  }

  ///获取钱包数量
  Future<int> getWalletCount() async {
    Database db = await getDataBase();
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $name'));
  }

  ///检查重复 true 重复  false 不重复
  Future<bool> checkNameRepetition(String walletName) async {
    Wallet wallet = await getWallet(walletName);
    return wallet != null;
  }

  Future<bool> checkKeyStoreRepetition(String keystore) async {
    Wallet wallet = await getWalletWithKeyStore(keystore);
    return wallet != null;
  }

  Future<bool> checkMnemonicWordRepetition(
      String mnemonicWord, String password) async {

    Wallet wallet = Wallet();
    wallet.mnemonicWord = mnemonicWord;
    wallet.password = password;
    await wallet.generatePrivateKeyWithMnemonic();
    print('checkMnemonicWordRepetition wallet.address ${wallet.address}');
    Wallet walletExist = await getWalletWithAddress(wallet.address);
    print('checkMnemonicWordRepetition walletExist ${walletExist}');
    return walletExist != null;
  }
}
