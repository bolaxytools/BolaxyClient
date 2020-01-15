import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///新增成功弹窗
class NewSuccessDialog extends Dialog {
  static bool isShow = false; //是否正在展示

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: GestureDetector(
        child: Center(
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
                      '新增成功',
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
        onTap: (){
          hideNewSuccessDialogDialog(context);
        },
      ),
    );
  }

  static void showNewSuccessDialogDialog(BuildContext context) {
    if (!isShow) {
      isShow = true;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return NewSuccessDialog();
          });
    }
  }

  static void hideNewSuccessDialogDialog(BuildContext context) {
    if (isShow) {
      Navigator.pop(context);
      isShow = false;
    }
  }
}
