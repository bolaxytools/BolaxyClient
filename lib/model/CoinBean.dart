class CoinBean {
  ///币名称
  String symbol;

  ///余额，10的18次方
  String balance;

  ///合约地址
  String contract;

  ///logo的url地址
  String logo;

  ///当币的名称使用, 描述
  String desc;

  ///精度
  int decimals;

  ///gas值
  int bap;

  static CoinBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CoinBean extCoinListBean = CoinBean();
    extCoinListBean.symbol = map['symbol'];
    extCoinListBean.balance = map['balance'];
    extCoinListBean.contract = map['contract'];
    extCoinListBean.logo = map['logo'];
    extCoinListBean.desc = map['desc'];
    extCoinListBean.decimals = map['decimals'];
    extCoinListBean.bap = map['bap'];
    return extCoinListBean;
  }

  Map toJson() => {
        "symbol": symbol,
        "balance": balance,
        "contract": contract,
        "logo": logo,
        "desc": desc,
        "decimals": decimals,
        "bap": bap,
      };
}
