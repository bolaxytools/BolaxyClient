/// chain_id : "chainid10001"
/// name : "默认圈"
/// server_ip : "33.66.88.99"
/// server_port : 4444
/// desc : "这是一个默认的圈子"

class Circle {
  ///圈子chainId
  String chainId;
  ///圈子名
  String name;
  ///圈子ip或域名
  String serverIp;
  ///圈子端口
  int serverPort;
  ///描述
  String desc;

  static Circle fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Circle circleBean = Circle();
    circleBean.chainId = map['chain_id'];
    circleBean.name = map['name'];
    circleBean.serverIp = map['server_ip'];
    circleBean.serverPort = map['server_port'];
    circleBean.desc = map['desc'];
    return circleBean;
  }

  Map toJson() => {
    "chain_id": chainId,
    "name": name,
    "server_ip": serverIp,
    "server_port": serverPort,
    "desc": desc,
  };


}