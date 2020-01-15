import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///文字可见的控件
class CharacterVisible extends StatefulWidget {
  bool visible = true;
  Color color;
  Function visibleCallback;

  CharacterVisible(this.visible, this.color, this.visibleCallback);

  @override
  State<StatefulWidget> createState() {
    return VisibleViewState();
  }
}

class VisibleViewState extends State<CharacterVisible> {
  @override
  Widget build(BuildContext context) {
    if (widget.visible) {
      return FlatButton(
          onPressed: () {
            setState(() {
              widget.visible = !widget.visible;
              widget.visibleCallback(widget.visible);
            });
          },
          child: Icon(
            Icons.visibility,
            size: ScreenUtil().setWidth(36),
            color: widget.color,
          ),
          padding: EdgeInsets.only(left: 0),);
    } else {
      return FlatButton(
          onPressed: () {
            setState(() {
              widget.visible = !widget.visible;
              widget.visibleCallback(widget.visible);
            });
          },
          padding: EdgeInsets.all(1),
          child: Icon(Icons.visibility_off,
              size: ScreenUtil().setWidth(36), color: widget.color));
    }
  }
}
