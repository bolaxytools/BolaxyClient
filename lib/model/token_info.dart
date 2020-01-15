import 'CoinBean.dart';

/// coin : {"symbol":"smb002","balance":"23","contract":"ctrrct002","logo":"b.logo","desc":"jsaf","decimals":18}
/// tx_list : {"txs":[{"tx_type":0,"addr_from":"bx0003","addr_to":"bx0001","amount":"800","miner_fee":"10","tx_hash":"hx0002","block_height":3,"tx_time":15011111111000,"memo":"tome","contract":"ctrrct002"},{"tx_type":0,"addr_from":"bx0001","addr_to":"bx0002","amount":"1000","miner_fee":"10","tx_hash":"hx0001","block_height":1,"tx_time":150000000000,"memo":"toyou","contract":"ctrrct002"}],"total":5}

class TokenInfo {
  CoinBean coin;
  TxListBean txList;

  static TokenInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TokenInfo tokenInfoBean = TokenInfo();
    tokenInfoBean.coin = CoinBean.fromMap(map['coin']);
    tokenInfoBean.txList = TxListBean.fromMap(map['tx_list']);
    return tokenInfoBean;
  }

  Map toJson() => {
    "coin": coin,
    "tx_list": txList,
  };
}

/// txs : [{"tx_type":0,"addr_from":"bx0003","addr_to":"bx0001","amount":"800","miner_fee":"10","tx_hash":"hx0002","block_height":3,"tx_time":15011111111000,"memo":"tome","contract":"ctrrct002"},{"tx_type":0,"addr_from":"bx0001","addr_to":"bx0002","amount":"1000","miner_fee":"10","tx_hash":"hx0001","block_height":1,"tx_time":150000000000,"memo":"toyou","contract":"ctrrct002"}]
/// total : 5

class TxListBean {
  List<TxsBean> txs;
  int total;

  static TxListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TxListBean tx_listBean = TxListBean();
    tx_listBean.txs = List()..addAll(
      (map['txs'] as List ?? []).map((o) => TxsBean.fromMap(o))
    );
    tx_listBean.total = map['total'];
    return tx_listBean;
  }

  Map toJson() => {
    "txs": txs,
    "total": total,
  };
}

/// tx_type : 0
/// addr_from : "bx0003"
/// addr_to : "bx0001"
/// amount : "800"
/// miner_fee : "10"
/// tx_hash : "hx0002"
/// block_height : 3
/// tx_time : 15011111111000
/// memo : "tome"
/// contract : "ctrrct002"

class TxsBean {
  int txType;
  String addrFrom;
  String addrTo;
  String amount;
  String minerFee;
  String txHash;
  int blockHeight;
  int txTime;
  String memo;
  String contract;

  static TxsBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TxsBean txsBean = TxsBean();
    txsBean.txType = map['tx_type'];
    txsBean.addrFrom = map['addr_from'];
    txsBean.addrTo = map['addr_to'];
    txsBean.amount = map['amount'];
    txsBean.minerFee = map['miner_fee'];
    txsBean.txHash = map['tx_hash'];
    txsBean.blockHeight = map['block_height'];
    txsBean.txTime = map['tx_time'];
    txsBean.memo = map['memo'];
    txsBean.contract = map['contract'];
    return txsBean;
  }

  Map toJson() => {
    "tx_type": txType,
    "addr_from": addrFrom,
    "addr_to": addrTo,
    "amount": amount,
    "miner_fee": minerFee,
    "tx_hash": txHash,
    "block_height": blockHeight,
    "tx_time": txTime,
    "memo": memo,
    "contract": contract,
  };
}