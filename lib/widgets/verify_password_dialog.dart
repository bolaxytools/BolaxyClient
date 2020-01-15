import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

///输入密码弹窗
class VerifyPasswordDialog extends Dialog {
  String walletPassword;
  Function successCallback;

  FocusNode focusNode = FocusNode();

  ///输入的密码
  String password;

  VerifyPasswordDialog(this.walletPassword, this.successCallback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: ScreenUtil().setWidth(0),
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(290),
                    decoration: ShapeDecoration(
                      color: Color(0xffEEEEEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                            topRight:
                                Radius.circular(ScreenUtil().setWidth(40))),
                      ),
                    ),
                    child: new Stack(
                      children: <Widget>[
                        Positioned(
                            left: ScreenUtil().setWidth(40),
                            top: ScreenUtil().setWidth(45),
                            child: Text(
                              '请输入密码',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(36),
                                  color: Color(0xFF1F3F59),
                                  fontWeight: FontWeight.w600),
                            )),
                        Positioned(
                            top: ScreenUtil().setWidth(40),
                            right: ScreenUtil().setWidth(40),
                            child: GestureDetector(
                              onTap: () {
                                focusNode.unfocus();
                                hideInputPasswordDialog(context);
                              },
                              child: Text(
                                '取消',
                                style: TextStyle(
                                    color: Color(0xFF95A2B3),
                                    fontSize: ScreenUtil().setSp(30)),
                                textAlign: TextAlign.center,
                              ),
                            )),
                        Positioned(
                          left: ScreenUtil().setWidth(40),
                          top: ScreenUtil().setWidth(150),
                          child: Container(
                            width: ScreenUtil().setWidth(670),
                            height: ScreenUtil().setWidth(84),
                            color: Color(0xFFF7F7FA),
                            child: TextField(
                              focusNode: focusNode,
                              onChanged: (text) {
                                password = text;
                              },
                              obscureText: true,
                              autofocus: true,
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(24)),
                              decoration: InputDecoration(
                                hintText: '输入密码',
                                contentPadding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(26),
                                    left: ScreenUtil().setWidth(30)),
                                border: InputBorder.none,
                              ),
                              onEditingComplete: () {
                                verify(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }

  void verify(BuildContext context) {
    if (password == walletPassword) {
      hideInputPasswordDialog(context);
      successCallback();
    } else {
      Fluttertoast.showToast(msg: '密码错误',gravity: ToastGravity.CENTER);
    }
  }

  static void showInputPasswordDialog(
      BuildContext context, String walletPassword, Function callback) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new VerifyPasswordDialog(walletPassword, callback);
        });
  }

  static void hideInputPasswordDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
