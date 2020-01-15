import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';

class SwitchCircleDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return SwitchCircle();
  }

  static void showSwitchCircle(BuildContext context, {Function callback}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new SwitchCircleDialog();
        }).then(callback);
  }

  static void hideSwitchCircle(BuildContext context) {
    Navigator.pop(context);
  }
}

class SwitchCircle extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SwitchCircleState();
  }
}

class SwitchCircleState extends State<SwitchCircle> {
  List<CircleDb> circles;

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
          height: ScreenUtil.screenHeight - ScreenUtil().setWidth(135),
          margin: EdgeInsets.only(top: ScreenUtil().setWidth(135)),
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(174, 179, 208, 0.2),
                  blurRadius: ScreenUtil().setWidth(30),
                  offset: Offset(0, ScreenUtil().setWidth(5)))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                topRight: Radius.circular(ScreenUtil().setWidth(40))),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: ScreenUtil().setWidth(45),
                  left: ScreenUtil().setWidth(40),
                  child: Text(
                    '切换圈子',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xFF2F3B53)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(56),
                  left: ScreenUtil().setWidth(200),
                  child: Text(
                    '共${circles != null ? circles.length : 0}个',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(26),
                        color: Color(0xFFB5BFCB)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(40),
                  child: GestureDetector(
                    child: Image.asset(
                      'images/close_homepage.png',
                      width: ScreenUtil().setWidth(35),
                      height: ScreenUtil().setWidth(35),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(145),
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setHeight(1250),
                    child: ListView.builder(
                        itemCount: circles != null ? circles.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return CircleItem(circles[index]);
                        }),
                  ))
            ],
          ),
        ));
  }

  Future<void> getData() async {
    Wallet wallet = await WalletDbProvider.walletDbProvider.getCurrentWallet();
    List<CircleDb> circles =
        await CircleDbProvider.circleDbProvider.getCircles(wallet.address);
    setState(() {
      this.circles = circles;
    });
  }
}

class CircleItem extends StatelessWidget {
  CircleDb circleDb;

  CircleItem(this.circleDb);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(194),
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: ScreenUtil().setWidth(670),
          height: ScreenUtil().setWidth(174),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/circle_card.png'),
                  fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: ScreenUtil().setWidth(43),
                  left: ScreenUtil().setWidth(30),
                  child: Text(
                    '圈子名称',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xFF97A3B4)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(80),
                  left: ScreenUtil().setWidth(30),
                  child: Text(
                    circleDb.name,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xFF2F3B53)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(30),
                  child: Text(
                    'CHAN ID',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xFF97A3B4)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(85),
                  right: ScreenUtil().setWidth(30),
                  child: Text(
                    circleDb.chainId,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xFF2F3B53)),
                  )),
            ],
          ),
        ),
        onTap: () {
          switchCircle(context);
        },
      ),
    );
  }

  Future<void> switchCircle(BuildContext context) async {
    Wallet wallet = await WalletDbProvider.walletDbProvider.getCurrentWallet();
    if (wallet.circleChainId != circleDb.chainId) {
      wallet.circleChainId = circleDb.chainId;
      await WalletDbProvider.walletDbProvider.update(wallet);
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context);
    }
  }
}
