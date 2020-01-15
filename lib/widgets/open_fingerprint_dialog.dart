import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/widgets/common_button.dart';

///开启指纹验证弹窗
class OpenFingerprintDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return new Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: Center(
          child: Container(
            width: ScreenUtil().setWidth(634),
            height: ScreenUtil().setWidth(496),
            decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(174, 179, 208, 0.2),
                      blurRadius: ScreenUtil().setWidth(30),
                      offset: Offset(0, ScreenUtil().setWidth(5)))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(12)))),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: ScreenUtil().setWidth(90),
                  child: Image.asset('images/fingerprint_verification.png'),
                  width: ScreenUtil().setWidth(116),
                  height: ScreenUtil().setWidth(116),
                ),
                Positioned(
                    top: ScreenUtil().setWidth(245),
                    child: Text(
                      '是否开启指纹验证？',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(32),
                          color: Color(0xFF2F3B53),
                          fontWeight: FontWeight.w600),
                    )),
                Positioned(
                    top: ScreenUtil().setWidth(360),
                    left: ScreenUtil().setWidth(40),
                    child: CommonButton(
                      '取消',
                      () {
                        hideOpenFingerprintDialog(context);
                      },
                      color: Color(0xFFD6DDE6),
                      width: ScreenUtil().setWidth(260),
                      height: ScreenUtil().setWidth(96),
                    )),
                Positioned(
                  top: ScreenUtil().setWidth(360),
                  right: ScreenUtil().setWidth(40),
                  child: CommonButton('确定', () {

                  },
                      color: Color(0xFF616EE3),
                      width: ScreenUtil().setWidth(260),
                      height: ScreenUtil().setWidth(96)),
                ),
              ],
            ),
          ),
        ));
  }

  static void showOpenFingerprintDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return OpenFingerprintDialog();
        });
  }

  static void hideOpenFingerprintDialog(BuildContext context) {
    Navigator.pop(context);
  }

  ///开启指纹验证
  void openFingerprint(){

  }
}
