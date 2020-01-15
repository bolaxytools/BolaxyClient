import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/model/CoinBean.dart';
import 'package:wallet/model/property.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/utils/string_utils.dart';

///选择币种弹窗
class ChooseCoinDialog extends Dialog {

  @override
  Widget build(BuildContext context) {
    return ChooseCoin();
  }

  static Future<List<Wallet>> getData() async {
    return await WalletDbProvider.walletDbProvider.getWallets();
  }

  static Future showChooseCoinDialog(BuildContext context, String address) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ChooseCoinDialog();
        }).then((coinBean){
      print('transferAccounts coinBean $coinBean');

      Application.router.navigateTo(context,
          '/transfer?symbol=${coinBean.desc}&balance=${coinBean.balance}&address=${address}'
              '&bap=${coinBean.bap}&contract=${coinBean.contract}'
              '&decimals=${Uri.encodeComponent(coinBean.decimals.toString())}');
    });
  }

  static void hideChooseCoinDialog(BuildContext context) {
    Navigator.pop(context);
  }
}

class ChooseCoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseCoinState();
  }

}

class ChooseCoinState extends State<ChooseCoin> {

  List<CoinBean> coinList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Container(
        width: ScreenUtil.screenWidth,
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                topRight: Radius.circular(ScreenUtil().setWidth(40))),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: ScreenUtil().setWidth(45),
                left: ScreenUtil().setWidth(40),
                child: Text(
                  '选择币种',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Color(0xFF2F3B53),
                      fontWeight: FontWeight.w600),
                )),
            Positioned(
                top: ScreenUtil().setWidth(56),
                left: ScreenUtil().setWidth(200),
                child: Text(
                  '共${coinList != null ? coinList.length : 0}个',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: Color(0xFFB5BFCB)),
                )),
            Positioned(
                top: ScreenUtil().setWidth(32),
                right: ScreenUtil().setWidth(40),
                width: ScreenUtil().setWidth(70),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 10,
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: Image.asset(
                    'images/close_homepage.png',
                    width: ScreenUtil().setWidth(40),
                    height: ScreenUtil().setWidth(40),
                  ),
                )),
            Positioned(
              top: ScreenUtil().setWidth(145),
              child: Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setWidth(1250),
                  child: CoinList(coinList)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    String address = await SharedPreferencesUtils.getCurrentWalletAddress();
    Property property = await NetUtils.getProperty(address);
    setState(() {
      coinList = List<CoinBean>();
      coinList.add(property.mainCoin);
      coinList.addAll(property.extCoinList);
    });
  }

}

class CoinList extends StatelessWidget {
  List<CoinBean> coinList;

  CoinList(this.coinList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: generateItem,
      itemCount: coinList != null ? coinList.length : 0,
      padding: EdgeInsets.only(top: 0),
    );
  }

  Widget generateItem(BuildContext context, int index) {
    return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setWidth(194),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(174),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(174, 179, 208, 0.2),
                      blurRadius: ScreenUtil().setWidth(20)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(12)))),
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: ScreenUtil().setWidth(40),
                    child: Container(
                      width: ScreenUtil().setWidth(6),
                      height: ScreenUtil().setWidth(50),
                      color: Color(0xFF3BD07F),
                    )),
                Positioned(
                  top: ScreenUtil().setWidth(47),
                  left: ScreenUtil().setWidth(56),
                  child: Image.network(coinList[index].logo,
                      width: ScreenUtil().setWidth(36),
                      height: ScreenUtil().setWidth(36)),
                ),
                Positioned(
                    top: ScreenUtil().setWidth(44),
                    left: ScreenUtil().setWidth(112),
                    child: Text(
                      coinList[index].symbol,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xFF2F3B53)),
                    )),
                Positioned(
                    right: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(44),
                    child: Text(
                      StringUtils.getProperty(coinList[index].balance,
                          point: 2),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xFF2F3B53)),
                    )),
              ],
            ),
          ),
          onTap: () {
            Navigator.pop(context, coinList[index]);
          },
        ));
  }
}
