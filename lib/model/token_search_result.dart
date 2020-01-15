/// total : 0
/// token_list : [{"contract":"contract10001","symbol":"sbl10001","logo":"http://www.image.com/b.png","desc":"sbl tok","followed":false},{"contract":"contract10002","symbol":"sbl10002","logo":"http://www.image.com/c.png","desc":"sbl en","followed":false},{"contract":"contract10003","symbol":"sbl10003","logo":"http://www.image.com/d.png","desc":"sbl coin","followed":false}]

class TokenSearchResult {
  int total;
  List<TokenListBean> tokenList;

  static TokenSearchResult fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TokenSearchResult tokenSearchResultBean = TokenSearchResult();
    tokenSearchResultBean.total = map['total'];
    tokenSearchResultBean.tokenList = List()..addAll(
      (map['token_list'] as List ?? []).map((o) => TokenListBean.fromMap(o))
    );
    return tokenSearchResultBean;
  }

  Map toJson() => {
    "total": total,
    "token_list": tokenList,
  };
}

/// contract : "contract10001"
/// symbol : "sbl10001"
/// logo : "http://www.image.com/b.png"
/// desc : "sbl tok"
/// followed : false

class TokenListBean {
  String contract;
  String symbol;
  String logo;
  String desc;
  bool followed;

  static TokenListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TokenListBean token_listBean = TokenListBean();
    token_listBean.contract = map['contract'];
    token_listBean.symbol = map['symbol'];
    token_listBean.logo = map['logo'];
    token_listBean.desc = map['desc'];
    token_listBean.followed = map['followed'];
    return token_listBean;
  }

  Map toJson() => {
    "contract": contract,
    "symbol": symbol,
    "logo": logo,
    "desc": desc,
    "followed": followed,
  };
}