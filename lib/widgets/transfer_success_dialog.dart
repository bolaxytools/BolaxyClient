import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///转账成功弹窗
class TransferSuccessDialog extends Dialog {
  static bool isShow = false; //是否正在展示

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: ScreenUtil().setWidth(317),
          height: ScreenUtil().setWidth(336),
          child: new Container(
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
                Container(
                  height: ScreenUtil().setWidth(120),
                  width: ScreenUtil().setWidth(120),
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(64)),
                  child: Image.asset('images/succeed_backups.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                  child: Text(
                    '转账成功',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        color: Color(0xFF2F3B53)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showTransferSuccessDialogDialog(BuildContext context) {
    if (!isShow) {
      isShow = true;
      showDialog(
          context: context,
//          barrierDismissible: true,
          builder: (BuildContext context) {
            return TransferSuccessDialog();
          });
    }
  }

  static void hideTransferSuccessDialogDialog(BuildContext context) {
    if (isShow) {
      Navigator.pop(context);
      isShow = false;
    }
  }
}
