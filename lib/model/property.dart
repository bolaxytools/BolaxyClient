import 'CoinBean.dart';

/// main_coin : {"symbol":"Box","balance":"100"}
/// ext_coin_list : [{"symbol":"Brc1","balance":"100000"},{"symbol":"Brc5","balance":"900000"}]

class Property {
  CoinBean mainCoin;
  List<CoinBean> extCoinList;

  static Property fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Property propertyBean = Property();
    propertyBean.mainCoin = CoinBean.fromMap(map['main_coin']);
    propertyBean.extCoinList = List()
      ..addAll((map['ext_coin_list'] as List ?? [])
          .map((o) => CoinBean.fromMap(o)));
    return propertyBean;
  }

  Map toJson() => {
        "main_coin": mainCoin,
        "ext_coin_list": extCoinList,
      };
}
