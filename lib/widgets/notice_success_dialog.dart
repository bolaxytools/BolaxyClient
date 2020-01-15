import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///提示弹窗
class NoticeDialog extends Dialog {
  static final successImagePath = 'images/succeed_backups.png';
  static final failedImagePath = 'images/failed.png';
  String notice;
  String imagePath; //图片
  Function callback; //关闭弹窗的回调

  static bool isClosed = false;

  NoticeDialog(this.notice, this.imagePath, {this.callback}); //提示文字

  @override
  Widget build(BuildContext context) {
    return Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: GestureDetector(
          child: Container(
            height: ScreenUtil().setHeight(1334),
            width: ScreenUtil().setWidth(750),
            color: Colors.transparent,
            child: Center(
              //保证控件居中效果
              child: SizedBox(
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
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                        child: Text(
                          notice,
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
          ),
          onTap: () {
            isClosed = true;
            hideNoticeDialog(context);
            if (callback != null) {
              callback();
            }
          },
        ));
  }

  static void showNoticeDialog(
      BuildContext context, String notice, String imagePath,
      {Function callback}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NoticeDialog(notice, imagePath, callback: callback);
        });

    isClosed = false;

    //延时2s执行
    Future.delayed(Duration(seconds: 2), () {
      if (!isClosed) {
        Navigator.of(context).pop();
        if (callback != null) {
          callback();
        }
      }
    });
  }

  static void hideNoticeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
