import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {

  static bool isShow = false;//是否正在展示

  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(
                    text,
                    style: new TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showLoading(BuildContext context) {
    if(!isShow){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return new LoadingDialog(
              text: "加载中...",
            );
          });
      isShow = true;
    }
  }

  static void hideLoading(BuildContext context){
    if(isShow){
      Navigator.pop(context);
      isShow = false;
    }
  }
}
