import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/model/circle.dart';
import 'package:wallet/pages/import_wallet/import_wallet_page.dart';
import 'package:wallet/utils/native_communication.dart';

class Wallet {
  String _name;

  ///密码
  String _password;

  ///密码提示
  String _notice;

  ///助记词的字符串
  String _mnemonicWord;

  ///加密后的私钥及其他数据的组合数组 第一个元素是地址，带0x前缀的16进制字符串，42个字符
  ///	第二个元素是公钥(压缩格式公钥)，带0x前缀的16进制字符串，68个字符
  ///	第三个元素为keystore格式的json字符串，已经过passphrase加密
  /// 第四个元素为助记词加密后的字符串，加密方式与keystore相同格式
  String _privateKey;

  ///keyStore
  String _keyStore;

  ///地址，带0x前缀的16进制字符串，42个字符
  String _address;

  ///公钥(压缩格式公钥)，带0x前缀的16进制字符串，68个字符
  String _publicKey;

  ///当前选择的圈子
  String _circleChainId;

  ///是否备份过 0 没有  1 有
  int _isBackup;

  Wallet({
    String name,
    String password,
    String notice,
    String mnemonicWord = '',
  }) {
    this._name = name;
    this._password = password;
    this._notice = notice;
    this._mnemonicWord = mnemonicWord;
    this._privateKey = '';
    this._keyStore = '';
    this._address = '';
    this._publicKey = '';
    this._circleChainId = '';
    this._isBackup = 0;
  }

  String get name => _name;

  set name(String name) => _name = name;

  String get password => _password;

  set password(String password) => _password = password;

  String get notice => _notice;

  set notice(String notice) => _notice = notice;

  String get mnemonicWord {
    return _mnemonicWord;
  }

  set mnemonicWord(String value) {
    _mnemonicWord = value;
  }

  String get privateKey => _privateKey;

  set privateKey(String value) {
    _privateKey = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get publicKey => _publicKey;

  set publicKey(String value) {
    _publicKey = value;
  }

  String get circleChainId => _circleChainId;

  set circleChainId(String value) {
    _circleChainId = value;
  }

  String get keyStore => _keyStore;

  set keyStore(String value) {
    _keyStore = value;
  }

  bool get isBackup => _isBackup == 1;

  set isBackup(bool value) {
    _isBackup = value ? 1 : 0;
  }

  Future<CircleDb> getCircle() async {
    if (circleChainId != null && circleChainId.isNotEmpty) {
      return await CircleDbProvider.circleDbProvider.getCircle(
          circleChainId, address);
    } else {
      return null;
    }
  }

  Wallet.fromJson(Map<String, dynamic> json) {
    _name = json['name'].toString();
    _password = json['password'];
    _notice = json['notice'];
    _mnemonicWord = json['mnemonicWord'];
    _privateKey = json['privateKey'];
    _keyStore = json['keyStore'];
    _address = json['address'];
    _publicKey = json['publicKey'];
    _circleChainId = json['circleChainId'];
    _isBackup = json['isBackup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['password'] = this._password;
    data['notice'] = this._notice;
    data['mnemonicWord'] = this._mnemonicWord;
    data['privateKey'] = this._privateKey;
    data['keyStore'] = this._keyStore;
    data['address'] = this._address;
    data['publicKey'] = this._publicKey;
    data['circleChainId'] = this._circleChainId;
    data['isBackup'] = this._isBackup;
    return data;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = _name;
    map['password'] = _password;
    map['notice'] = _notice;
    map['mnemonicWord'] = _mnemonicWord;
    map['privateKey'] = _privateKey;
    map['keyStore'] = _keyStore;
    map['address'] = _address;
    map['publicKey'] = _publicKey;
    map['circleChainId'] = _circleChainId;
    map['isBackup'] = _isBackup;
    return map;
  }

  Future<Wallet> generatePrivateKey() async {
    print('generatePrivateKey password $password');
    print('generatePrivateKey address ${address.isEmpty}');
    if (password.isNotEmpty && address.isEmpty) {
      privateKey = await NativeCommunication.generatePrivateKey(_password);
      List<dynamic> array = jsonDecode(_privateKey);
      address = array[0];
      print('generatePrivateKey address $address');
      publicKey = array[1];
      keyStore = array[2];
    }
    return this;
  }

  ///导入助记词时 生成地址
  Future<Wallet> generatePrivateKeyWithMnemonic() async {
    print('generatePrivateKeyWithMnemonic password $password');
    if (password.isNotEmpty) {
      privateKey =
      await NativeCommunication.ImportFromMnemonic(mnemonicWord, password);
      List<dynamic> array = jsonDecode(_privateKey);
      address = array[0];
      print('generatePrivateKeyWithMnemonic address $address');
      publicKey = array[1];
      keyStore = array[2];
    }
    return this;
  }
  ///导入keystore时 生成地址
  Future<Wallet> generatePrivateKeyWithKeyStore() async {
    print('generatePrivateKeyWithKeyStore keyStore $keyStore');
    if (keyStore.isNotEmpty && address.isEmpty) {
      String result =
      await NativeCommunication.ImportKeystore(keyStore, password);
      if(result != null && result.isNotEmpty){
        print('generatePrivateKeyWithKeyStore result $result');
        List<dynamic> array = jsonDecode(result);
        address = array[0];
        print('generatePrivateKeyWithKeyStore address $address');
        print('generatePrivateKeyWithKeyStore array.length ${array.length}');
        publicKey = array[1];
        array.add(keyStore);
        privateKey = jsonEncode(array);
      } else {
        Fluttertoast.showToast(msg: '密码不匹配');
      }
    }
    return this;
  }

}
