import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///通用按钮
class CommonButton extends StatefulWidget {
  bool enable = true; //是否可以点击
  double width; //宽
  double height;

//  double width = ScreenUtil().setWidth(556); //宽
//  double height = ScreenUtil().setWidth(96); //高
  String text;
  num textSize;
  Color color; //默认蓝色
  Color colorDisabled; //不可点击时的颜色 默认灰色
  String textDisabled; //不可点击时的文字 默认与可点击时相同
  VoidCallback callback;

  @override
  State<StatefulWidget> createState() {
    return ConfirmButtonState();
  }

  CommonButton(this.text, this.callback,
      {this.enable = true,
      this.width,
      this.height,
      this.textSize = 32,
      this.color,
      this.textDisabled,
      this.colorDisabled = const Color(0xFFD6DDE6)});

  void setEnable(bool enable) {
    this.enable = enable;
  }
}

class ConfirmButtonState extends State<CommonButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(
//          left: ScreenUtil().setWidth(97),
//          top: ScreenUtil().setWidth(50),
//          bottom: ScreenUtil().setWidth(50)),
      width: widget.width,
      height: widget.height,
      child: FlatButton(
        onPressed: () {
          onClick();
        },
        child: Text(
            widget.enable
                ? widget.text
                : (widget.textDisabled.isNotEmpty
                    ? widget.textDisabled
                    : widget.text),
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(widget.textSize),
                fontWeight: FontWeight.normal)),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(50)))),
        color: widget.enable ? widget.color : widget.colorDisabled,
        padding: EdgeInsets.only(left: 5, right: 5),
      ),
    );
  }

  void onClick() {
    if (widget.enable) {
      widget.callback();
    }
  }
}
