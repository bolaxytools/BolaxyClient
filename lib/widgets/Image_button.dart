import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget{
  final VoidCallback callback;
  final double width;
  final double height;

  ImageButton({
    @required this.callback,
    this.width = 250,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
//        Image.asset('')
      ],
    );
//      Container(
//      width: width,
//      height: height,
//      child: RaisedButton(
//        onPressed: callback,
//        color: Colors.red,
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(height / 2))),
//        child: Text(
//          content,
//          style: TextStyle(color: Colors.white, fontSize: fontSize),
//        ),
//      ),
//    );
  }

}