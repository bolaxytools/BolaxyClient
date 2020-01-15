import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'character_visible.dart';

///可以控制可见性的输入框
class InputBox extends StatefulWidget {
  bool visible = false; //文字是否可见
  String hint;
  int hintColor;
  Function function;
  String text;

  InputBox(this.visible, this.hint, this.function, {
    this.hintColor = 0xFFB5BFCB
  });

  @override
  State<StatefulWidget> createState() {
    return InputBoxState();
  }
}

class InputBoxState extends State<InputBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.visible,
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          widget.function(text);
        });
      },
      style: TextStyle(fontSize: ScreenUtil().setSp(24)),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: Color(widget.hintColor)),
        border: InputBorder.none,
        suffixIcon:
        CharacterVisible(widget.visible, Colors.grey, (bool visible) {
          setState(() {
            widget.visible = visible;
          });
        }),
      ),
    );
  }
}