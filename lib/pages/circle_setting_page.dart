import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/scan_utils.dart';

///圈子设置
class CircleSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CircleSettingPageState();
  }
}

class CircleSettingPageState extends State<CircleSettingPage> {
  List<CircleDb> circles;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: ScreenUtil().setWidth(60),
              left: ScreenUtil().setWidth(20),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: ScreenUtil().setWidth(50),
                color: Color(0xFFB5BFCB),
                onPressed: () {
                  Application.router.pop(context);getData();
                },
              )),
          Positioned(
              right: ScreenUtil().setWidth(40),
              top: ScreenUtil().setWidth(85),
              child: GestureDetector(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.add_circle_outline,
                      size: ScreenUtil().setWidth(35),
                      color: Color(0xFFB5BFCB),
                    ),
                    Text(
                      '添加圈子',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0xFFB5BFCB)),
                    )
                  ],
                ),
                onTap: () {
                  scan();
                },
              )),
          Positioned(
              top: ScreenUtil().setWidth(150),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '圈子设置',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(48), color: Color(0xFF2F3B53)),
              )),
          Positioned(
              top: ScreenUtil().setWidth(270),
              child: Container(
                width: ScreenUtil.screenWidth,
                height: ScreenUtil.screenHeight - ScreenUtil().setWidth(180),
                child: ListView.builder(
                    itemCount: circles != null ? circles.length : 0,
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (BuildContext context, int index) {
                      return CircleItem(circles[index],(){
                        getData();
                      });
                    }),
              ))
        ],
      ),
    );
  }

  Future<void> getData() async {
    Wallet wallet = await WalletDbProvider.walletDbProvider.getCurrentWallet();
    List<CircleDb> circles =
        await CircleDbProvider.circleDbProvider.getCircles(wallet.address);
    setState(() {
      this.circles = circles;
    });
  }

  Future<void> scan() async {
    String result = await ScanUtils.toScan();
    if (result.isNotEmpty) {
      Application.router.navigateTo(
          context, '/addCircle?circle_string=${Uri.encodeComponent(result)}')
          .then((isRefresh) {
        getData();
      });
    } else {
      Fluttertoast.showToast(msg: '扫描结果有误');
    }
  }

}

class CircleItem extends StatelessWidget {
  CircleDb circleDb;
  Function callback;

  CircleItem(this.circleDb, this.callback);

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
          Application.router.navigateTo(context,
              '/circleDetail?chain_id=${circleDb
                  .chainId}&wallet_address=${circleDb.walletAddress}').then((
              isRefresh) {
            if (isRefresh != null && isRefresh) {
              callback();
            }
          });
        },
      ),
    );
  }
}
