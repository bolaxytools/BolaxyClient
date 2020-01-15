import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';

///备份成功弹窗
class SwitchWalletDialog extends Dialog {
  List<Wallet> wallets;
  Function callback;

  SwitchWalletDialog(this.wallets, this.callback);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Container(
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
                  '切换钱包',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Color(0xFF2F3B53),
                      fontWeight: FontWeight.w600),
                )),
            Positioned(
                top: ScreenUtil().setWidth(56),
                left: ScreenUtil().setWidth(200),
                child: Text(
                  '共${wallets != null ? wallets.length : 0}个',
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
                    hideSwitchWalletDialog(context);
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
              child:Container(
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(1334) - ScreenUtil().setWidth(260),
                  child: WalletList(wallets, callback)),
            )
          ],
        ),
      ),
    );
  }

  static Future<List<Wallet>> getData() async {
    List<Wallet> result = await WalletDbProvider.walletDbProvider.getWallets();
    //重新排序，当前的放在第一位
    Wallet currentWallet;
    String currentWalletAddress = await SharedPreferencesUtils.getCurrentWalletAddress();
    for(Wallet wallet in result){
      if(wallet.address == currentWalletAddress){
        currentWallet = wallet;
        result.remove(wallet);
        break;
      }
    }
    result.insert(0, currentWallet);
    return result;
  }

  static Future showSwitchWalletDialog(
      BuildContext context, Function callback) async {
    List<Wallet> wallets = await getData();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SwitchWalletDialog(wallets, callback);
        });
  }

  static void hideSwitchWalletDialog(BuildContext context) {
    Navigator.pop(context);
  }
}

class WalletList extends StatelessWidget {
  List<Wallet> wallets;

  Function callback;

  List<String> imageBgs = [
    'images/wallet1.png',
    'images/wallet2.png',
    'images/wallet3.png',
    'images/wallet4.png',
    'images/wallet5.png',
  ];

  WalletList(this.wallets, this.callback);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: generateItem,
      itemCount: wallets != null ? wallets.length : 0,
      padding: EdgeInsets.only(top: 0,bottom: ScreenUtil().setWidth(80)),
    );
  }

  Widget generateItem(BuildContext context, int index) {
    return Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil().setWidth(238),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(218),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imageBgs[index % 5]), fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: ScreenUtil().setWidth(28),
                    left: ScreenUtil().setWidth(30),
                    child: Text(
                      wallets[index].name,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Colors.white),
                    )),
                Positioned(
                    top: ScreenUtil().setWidth(82),
                    left: ScreenUtil().setWidth(30),
                    width: ScreenUtil().setWidth(600),
                    child: Text(
                      wallets[index].address,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0x99FFFFFF)),
                    ))
              ],
            ),
          ),
          onTap: () {
            callback(wallets[index].address);
          },
        ));
  }
}
