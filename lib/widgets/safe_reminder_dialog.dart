import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///输入密码弹窗
class SafeReminderDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new
      Align(
        alignment: Alignment.topCenter,
        //保证控件居中效果
        child: new SizedBox(
          width: ScreenUtil().setWidth(634),
//          height: ScreenUtil().setWidth(672),
          height: ScreenUtil().setWidth(972),
          child: new Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(300)),
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                    child: Image.asset(
                      'images/firbid_backups.png',
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setWidth(120),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                  child: Text(
                    '安全提醒',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        color: Color(0xFF2F3B53)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(20)),
                  child: Text(
                    '为您的资产安全考虑，请勿截屏\n截屏存入相册后，有可能同步至云端，导致助记词泄露。\n建议您将助记词备份到断网的物理介质上，例如抄写在白纸上，并妥善保存。',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(26),
                        color: Color(0xFF95A2B3)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(67)),
                  width: ScreenUtil().setWidth(290),
                  height: ScreenUtil().setWidth(96),
                  child: FlatButton(
                    onPressed: () {
                      hideSafeReminderDialog(context);
                    },
                    child: Text('我知道了',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(32),
                            fontWeight: FontWeight.normal)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(50)))),
                    color: Color(0xFF616EE3),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showSafeReminderDialog(BuildContext context) {
    showDialog(
        context: context,
//        barrierDismissible: false,
        builder: (BuildContext context) {
          return SafeReminderDialog();
        });
  }

  static void hideSafeReminderDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
