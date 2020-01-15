import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';

///创建或者导入钱包
class CreateOrImportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF7F8FF),
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
        child: Stack(
          children: <Widget>[
            Positioned(
                left: ScreenUtil().setWidth(114),
                top: ScreenUtil().setWidth(200),
                child: Image.asset(
                  'images/image_creat_wallet.png',
                  width: ScreenUtil().setWidth(522),
                  height: ScreenUtil().setWidth(535),
                )),
            Positioned(
                top: ScreenUtil().setWidth(800),
                left: ScreenUtil().setWidth(266),
                child: Text('Hello!',
                    style: TextStyle(
                        color: Color(0xFF2F3B53),
                        fontSize: ScreenUtil().setSp(76),
                        fontWeight: FontWeight.w600))),
            Positioned(
              bottom: ScreenUtil().setWidth(218),
              left: ScreenUtil().setWidth(97),
              width: ScreenUtil().setWidth(556),
              height: ScreenUtil().setWidth(96),
              child: FlatButton(
                onPressed: () {
                  _createWallet(context);
                },
                child: Text('创建钱包',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.normal)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(50)))),
                color: Color(0xFF616EE3),
              ),
            ),
            Positioned(
              bottom: ScreenUtil().setWidth(92),
              left: ScreenUtil().setWidth(97),
              width: ScreenUtil().setWidth(556),
              height: ScreenUtil().setWidth(96),
              child: FlatButton(
                onPressed: () {
                  _importWallet(context);
                },
                child: Text('导入钱包',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.normal)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(50)))),
                color: Color(0xFFEDC288),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _createWallet(BuildContext context) {
    Application.router.navigateTo(context, '/createWallet');
  }

  void _importWallet(BuildContext context) {
    Application.router.navigateTo(context, '/importWallet');
  }
}
