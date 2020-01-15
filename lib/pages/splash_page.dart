import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/utils/routes.dart';
import 'package:wallet/widgets/bottom_navigation.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/widgets/safe_reminder_dialog.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State {
  Timer timer;

  @override
  void initState() {
    super.initState();
    _startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    ///初始化一些组件
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        color: Color(0xFFF2F4FF),
        child: Stack(
          children: <Widget>[
            Positioned(
                child: Image.asset(
              'images/background_loading.png',
              width: ScreenUtil.screenWidth,
              height: ScreenUtil().setWidth(832),
              fit: BoxFit.cover,
            )),
            Positioned(
              left: ScreenUtil().setWidth(297),
              top: ScreenUtil().setWidth(390),
              child: Image.asset(
                'images/wallet_logo.png',
                width: ScreenUtil().setWidth(154),
                height: ScreenUtil().setWidth(252),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                left: ScreenUtil().setWidth(200),
                bottom: ScreenUtil().setWidth(60),
                child: Text(
                  '- BOX Wallet 是一款数字资产管理APP -',
                  style: TextStyle(fontSize: ScreenUtil().setSp(20)),
                ))
          ],
        ),
      ),
    );
  }

  void _toHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
        (route) => route == null);

//    Application.router
//        .navigateTo(context, '/backupMnemonicWord?name="test"&password="11111111"');
//    SafeReminderDialog.showSafeReminderDialog(context);
  }

  void toCreateWallet() {
    Application.router.navigateTo(context, Routes.createOrImport);
  }

  void _startCountDown() {
    //一段时间后跳转首页
    timer = new Timer.periodic(Duration(milliseconds: 2000), (timer) async {
      if (timer.tick == 1) {
        timer.cancel();
        skip();
      }
    });
  }

  ///跳转
  Future skip() async {
    WalletDbProvider walletDbProvider = new WalletDbProvider();
    int count = await walletDbProvider.getWalletCount();
    print('skip $count');
    if (count == 0) {
      toCreateWallet();
    } else {
      _toHomePage(context);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    timer = null;
    super.dispose();
  }
}
