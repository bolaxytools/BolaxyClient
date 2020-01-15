import 'package:wallet/model/circle.dart';

class CircleDb {
  ///圈子chainId
  String _chainId;

  ///圈子名
  String _name;

  ///圈子ip或域名
  String _serverIp;

  ///圈子端口
  int _serverPort;

  ///描述
  String _desc;

  ///所在的钱包的地址
  String _walletAddress;

  ///是否是默认圈子，默认圈子无法删除
  int _isDefault;

  CircleDb.name();

  CircleDb(Circle circle, String walletAddress) {
    this.chainId = circle.chainId;
    this.name = circle.name;
    this.serverIp = circle.serverIp;
    this.serverPort = circle.serverPort;
    this.desc = circle.desc;
    this.walletAddress = walletAddress;
    this.isDefault = false;
  }

  String get chainId => _chainId;

  set chainId(String value) {
    _chainId = value;
  }

  String get name => _name;

  String get walletAddress => _walletAddress;

  set walletAddress(String value) {
    _walletAddress = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  int get serverPort => _serverPort;

  set serverPort(int value) {
    _serverPort = value;
  }

  String get serverIp => _serverIp;

  set serverIp(String value) {
    _serverIp = value;
  }

  set name(String value) {
    _name = value;
  }

  bool get isDefault => _isDefault == 1;

  set isDefault(bool value) {
    _isDefault = value ? 1 : 0;
  }

  CircleDb.fromJson(Map<String, dynamic> json) {
    _chainId = json['chainId'];
    _name = json['name'];
    _serverIp = json['serverIp'];
    _serverPort = json['serverPort'];
    _desc = json['desc'];
    _walletAddress = json['walletAddress'];
    _isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chainId'] = this._chainId;
    data['name'] = this._name;
    data['serverIp'] = this._serverIp;
    data['serverPort'] = this._serverPort;
    data['desc'] = this._desc;
    data['walletAddress'] = this._walletAddress;
    data['isDefault'] = this._isDefault;
    return data;
  }
}
