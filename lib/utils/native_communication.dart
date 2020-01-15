import 'dart:convert';

import 'package:flutter/services.dart';

///与原生通信
class NativeCommunication {
  static const platform = const MethodChannel('com.twose.wallet');

  static Future<String> generatePrivateKey(String password) async {
    try {
      String privateKey =
          await platform.invokeMethod('generatePrivateKey', password);
      print('generatePrivateKey $privateKey');
      return privateKey;
    } on PlatformException catch (e) {}
  }

  ///serialized 格式为GeneratePrivateKey 返回结果第四个元素，不可以为空
  static Future<String> getMnemonicWords(
      String password, String serialized) async {
    print('getMnemonicWords password $password');
    print('getMnemonicWords serialized $serialized');
    Map<String, dynamic> params = {
      'password': password,
      'serialized': serialized,
    };
    try {
      String mnemonicWordsString =
          await platform.invokeMethod('getMnemonicWords', jsonEncode(params));
      return mnemonicWordsString;
    } on PlatformException catch (e) {}
  }

  ///json 格式为GeneratePrivateKey 返回结果第三个元素 不可以为空字符串
  static Future<String> generateTransaction(
      String json,
      String password,
      String from, //转账人的地址
      String gasPrice, //手续费价格
      String to, //接收人的地址
      String value, //转账的金额
      String nonce, //标识
      String gas) //交易使用手续费的上限
  async {
    print('generateTransaction json $json');
    print('generateTransaction password $password');
    print('generateTransaction from $from');
    print('generateTransaction gasPrice $gasPrice');
    print('generateTransaction to $to');
    print('generateTransaction value $value');
    print('generateTransaction nonce $nonce');
    print('generateTransaction gas $gas');
    try {
      Map<String, dynamic> params = {
        'json': json,
        'password': password,
        'from': from,
        'gasPrice': gasPrice,
        'to': to,
        'value': value,
        'nonce': nonce,
        'gas': gas,
      };

      String transaction = await platform.invokeMethod(
          'generateTransaction', jsonEncode(params));
      print('generateTransaction generateTransaction $transaction');
      return transaction;
    } on PlatformException catch (e) {}
  }

  ///为智能合约币交易 生成交易签名
  static Future<String> signERC20Tx(
    String json,
    String password,
    String from, //转账人的地址
    String gasPrice, //手续费价格
    String toChain, //接收链的地址
    String value, //转账的金额
    String nonce, //标识
    String gas,
    String to, //接收人的地址
    String unit, //币的单位
  ) //交易使用手续费的上限
  async {
    print('signERC20Tx json $json');
    print('signERC20Tx password $password');
    print('signERC20Tx from $from');
    print('signERC20Tx gasPrice $gasPrice');
    print('signERC20Tx toChain $toChain');
    print('signERC20Tx value $value');
    print('signERC20Tx nonce $nonce');
    print('signERC20Tx gas $gas');
    print('signERC20Tx to $to');
    print('signERC20Tx unit $unit');
    try {
      Map<String, dynamic> params = {
        'json': json,
        'password': password,
        'from': from,
        'gasPrice': gasPrice,
        'toChain': toChain,
        'value': value,
        'nonce': nonce,
        'gas': gas,
        'to': to,
        'unit': unit,
      };

      String transaction =
          await platform.invokeMethod('signERC20Tx', jsonEncode(params));
      print('signERC20Tx transaction $transaction');
      return transaction;
    } on PlatformException catch (e) {}
  }

  ///检查助记词是否有效
  static Future<bool> checkMnemonic(String mnemonic) async {
    print('checkMnemonic mnemonic $mnemonic');
    try {
      bool isValid = await platform.invokeMethod('checkMnemonic', mnemonic);
      print('checkMnemonic $isValid');
      return isValid;
    } on PlatformException catch (e) {}
  }

  static Future<String> ImportFromMnemonic(
      String mnemonic, String password) async {
    print('ImportFromMnemonic mnemonic $mnemonic');
    print('ImportFromMnemonic password $password');
    Map<String, dynamic> params = {
      'mnemonic': mnemonic,
      'password': password,
    };
    try {
      String privateKey =
          await platform.invokeMethod('importFromMnemonic', jsonEncode(params));
      print('ImportFromMnemonic $privateKey');
      return privateKey;
    } on PlatformException catch (e) {}
  }

  static Future<String> ImportKeystore(String keystore, String password) async {
    print('ImportKeystore keystore $keystore');
    print('ImportKeystore password $password');
    Map<String, dynamic> params = {
      'keystore': keystore,
      'password': password,
    };
    try {
      String privateKey =
          await platform.invokeMethod('importKeystore', jsonEncode(params));
      print('ImportKeystore $privateKey');
      return privateKey;
    } on PlatformException catch (e) {}
  }
}
