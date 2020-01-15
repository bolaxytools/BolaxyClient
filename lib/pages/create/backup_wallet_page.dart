import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/widgets/input_password_dialog.dart';
import 'package:wallet/Application.dart';

///备份钱包
class BackupWalletPage extends StatelessWidget {

  String walletName;///钱包的名称
  String walletPassword;///钱包的密码

  BackupWalletPage(this.walletName, this.walletPassword);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setWidth(64)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.arrow_back),
//                    iconSize: ScreenUtil().setWidth(50),
//                    color: Color(0xFFB5BFCB),
//                    onPressed: () {
//                      Navigator.pop(context);
//                    },
//                  ),
                  Container(
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(570)),
                    child: GestureDetector(
                        onTap: () {
                          Application.router
                              .navigateTo(context, '/bottomNavigation');
                        },
                        child: Text(
                          '跳过备份',
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(28),
                              color: Color(0xFF616EE3)),
                        )),
                  )
                ],
              )),
          Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text('备份钱包',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(48),
                      color: Color(0xFF2F3B53)))),
          Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(70)),
              child: Text('立即备份你的钱包',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: Color(0xFF2F3B53)))),
          Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(40)),
              child: Text('备份钱包：导出「助记词」并抄写到安全的地方，千万不要保存到网络上。然后尝试转入、转出小额资产开始使用',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      color: Color(0xFF95A2B3)))),
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(97),
                top: ScreenUtil().setWidth(160)),
            width: ScreenUtil().setWidth(556),
            height: ScreenUtil().setWidth(96),
            child: FlatButton(
              onPressed: () {
                backupWallet(context);
              },
              child: Text('备份钱包',
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
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(290),
                top: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(290)),
            child: GestureDetector(
                onTap: () {
                  checkBackupCourse(context);
                },
                child: Text('查看备份教程',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xFF616EE3)))),
          ),
        ],
      ),
    );
  }

  ///跳过备份
  void skipBackup() {}

  ///备份钱包
  void backupWallet(BuildContext context) {
    InputPasswordDialog.showInputPasswordDialog(
        context, walletName, walletPassword);
  }

  ///查看备份教程
  void checkBackupCourse(BuildContext context) {
    Application.router.navigateTo(context, '/web?url=${Uri.encodeComponent(NetUtils.host + '/help')}');
  }
}
