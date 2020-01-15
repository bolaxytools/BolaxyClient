
///地址
class Address {
  ///地址名称
  String _name;
  ///地址
  String _address;

  Address(this._name, this._address);

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Address.fromJson(Map<String, dynamic> json) {
    _name = json['name'].toString();
    _address = json['address'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['address'] = this._address;
    return data;
  }

}
