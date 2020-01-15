/// txs : [{"tx_type":1,"addr_from":"0x343e7F717d268903F6033766cE1D210a3D82C097","addr_to":"0x9c7d0b2f633c7896f07b64f1f5fe71e748169bf5","amount":"10000000000000000000","miner_fee":"51896","tx_hash":"0xb799c7fcc315934e9c66906755b45624e2cfda1bdf5be434a3112f7fc2cc50cc","block_height":60,"tx_time":1578281036829,"memo":"","contract":"0xa79d70c4a0b3a31043541cd593828170bf037afe","status":1,"symbol":"BUG"},{"tx_type":1,"addr_from":"0x343e7F717d268903F6033766cE1D210a3D82C097","addr_to":"0x9c7D0b2F633C7896f07b64f1F5FE71e748169bF5","amount":"100000000000000000000","miner_fee":"21000","tx_hash":"0xc5c54dea945d37d929fa0f69a935d3d9a3e390fd8bed4e7db35c1c1d8193c8b6","block_height":59,"tx_time":1578277983166,"memo":"","contract":"BUSD","status":1,"symbol":"BUSD"}]
/// total : 62

class TransactionHistory {
  List<TxsBean> txs;
  int total;

  static TransactionHistory fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TransactionHistory transactionHistoryBean = TransactionHistory();
    transactionHistoryBean.txs = List()..addAll(
      (map['txs'] as List ?? []).map((o) => TxsBean.fromMap(o))
    );
    transactionHistoryBean.total = map['total'];
    return transactionHistoryBean;
  }

  Map toJson() => {
    "txs": txs,
    "total": total,
  };
}

/// tx_type : 1
/// addr_from : "0x343e7F717d268903F6033766cE1D210a3D82C097"
/// addr_to : "0x9c7d0b2f633c7896f07b64f1f5fe71e748169bf5"
/// amount : "10000000000000000000"
/// miner_fee : "51896"
/// tx_hash : "0xb799c7fcc315934e9c66906755b45624e2cfda1bdf5be434a3112f7fc2cc50cc"
/// block_height : 60
/// tx_time : 1578281036829
/// memo : ""
/// contract : "0xa79d70c4a0b3a31043541cd593828170bf037afe"
/// status : 1
/// symbol : "BUG"

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
  int status;
  String symbol;

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
    txsBean.status = map['status'];
    txsBean.symbol = map['symbol'];
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
    "status": status,
    "symbol": symbol,
  };
}