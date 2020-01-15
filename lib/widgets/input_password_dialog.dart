import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/widgets/safe_reminder_dialog.dart';

///输入密码弹窗
class InputPasswordDialog extends Dialog {
  String walletName;
  String walletPassword;

  String password;

  InputPasswordDialog(this.walletName, this.walletPassword);

  @override
  Widget build(BuildContext context) {
    return new Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            new Container(
              width: ScreenUtil().setWidth(540),
              height: ScreenUtil().setWidth(280),
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(340)),
              decoration: ShapeDecoration(
                color: Color(0xffEEEEEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(24)),
                  ),
                ),
              ),
              child: new Stack(
                children: <Widget>[
                  Positioned(
                      left: ScreenUtil().setWidth(190),
                      top: ScreenUtil().setWidth(37),
                      child: Text(
                        '请输入密码',
                        style: TextStyle(fontSize: ScreenUtil().setSp(32)),
                      )),
                  Positioned(
                    left: ScreenUtil().setWidth(32),
                    top: ScreenUtil().setWidth(100),
                    child: Container(
                      width: ScreenUtil().setWidth(474),
                      height: ScreenUtil().setWidth(60),
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(20)),
                      color: Color(0xFFFFFFFF),
                      child: TextField(
                        onChanged: (text) {
                          password = text;
                        },
                        obscureText: true,
                        style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                        decoration: InputDecoration(
                          hintText: '密码',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      width: ScreenUtil().setWidth(270),
                      height: ScreenUtil().setWidth(86),
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(192)),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(77, 77, 77, 0.78),
                                  width: 0.2,
                                  style: BorderStyle.solid),
                              right: BorderSide(
                                  color: Color.fromRGBO(77, 77, 77, 0.78),
                                  width: 0.2,
                                  style: BorderStyle.solid))),
                      child: GestureDetector(
                        onTap: () {
                          hideInputPasswordDialog(context);
                        },
                        child: Text(
                          '取消',
                          style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: ScreenUtil().setSp(32)),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  Container(
                      width: ScreenUtil().setWidth(270),
                      height: ScreenUtil().setWidth(86),
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(270),
                          top: ScreenUtil().setWidth(192),
                          right: 0),
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(
                            color: Color.fromRGBO(77, 77, 77, 0.78),
                            width: 0.2,
                            style: BorderStyle.solid),
                      )),
                      child: GestureDetector(
                        onTap: () {
                          print('111');
                          verifyPassword(context, password);
                        },
                        child: Text(
                          '确认',
                          style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: ScreenUtil().setSp(32)),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ),
            ),
          ],
        )));
  }

  static void showInputPasswordDialog(
      BuildContext context, String walletName, String walletPassword) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return InputPasswordDialog(walletName, walletPassword);
        });
  }

  static void hideInputPasswordDialog(BuildContext context) {
    Navigator.pop(context);
  }

  void verifyPassword(BuildContext context, String password) {
    if (password == walletPassword) {
      hideInputPasswordDialog(context);

      Application.router.navigateTo(context,
          '/backupMnemonicWord?name=${Uri.encodeComponent(walletName)}&password=${Uri.encodeComponent(walletPassword)}');
      SafeReminderDialog.showSafeReminderDialog(context);
    } else {
      Fluttertoast.showToast(msg: '密码不正确');
    }
  }
}
