import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/widgets/common_button.dart';

///圈子详情
class CircleDetailPage extends StatefulWidget {
  String chainId;
  String walletAddress;

  CircleDetailPage(this.chainId, this.walletAddress);

  @override
  State<StatefulWidget> createState() {
    return CircleDetailPageState();
  }
}

class CircleDetailPageState extends State<CircleDetailPage> {
  CircleDb circleDb;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil.screenWidth,
        height: ScreenUtil.screenHeight,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background_circle.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(64)),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: ScreenUtil().setWidth(50),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(30)),
                child: Text(
                  '圈子详情',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(48), color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(60)),
                width: ScreenUtil().setWidth(670),
                height: ScreenUtil().setWidth(378),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/card_circle.png'),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(30),
                        child: Text(
                          '圈子名称',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xFF97A3B4)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(67),
                        child: Text(
                          'LEE的圈子',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(36),
                              color: Color(0xFF2F3B53)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(147),
                        child: Text(
                          '服务IP',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xFF97A3B4)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(184),
                        child: Text(
                          circleDb != null ? circleDb.serverIp : '',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xFF2F3B53)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(324),
                        top: ScreenUtil().setWidth(147),
                        child: Text(
                          '服务端口',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xFF97A3B4)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(324),
                        top: ScreenUtil().setWidth(184),
                        child: Text(
                          circleDb != null
                              ? circleDb.serverPort.toString()
                              : '',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xFF2F3B53)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(536),
                        top: ScreenUtil().setWidth(147),
                        child: Text(
                          'CHAN ID',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xFF97A3B4)),
                        )),
                    Positioned(
                        right: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(184),
                        child: Text(
                          circleDb != null ? circleDb.chainId : '',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xFF2F3B53)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(254),
                        child: Text(
                          '备注',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(24),
                              color: Color(0xFF97A3B4)),
                        )),
                    Positioned(
                        left: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(291),
                        child: Text(
                          circleDb != null ? circleDb.desc : '',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xFF2F3B53)),
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(20)),
                width: ScreenUtil().setWidth(670),
                height: ScreenUtil().setWidth(640),
                decoration: new BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFAEB3D0),
                    )
                  ],
                  // 边色与边宽度
                  color: Colors.white,
                  // 底色
                  //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
                  borderRadius: new BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(12))), // 也可控件一边圆角大小
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                        top: ScreenUtil().setWidth(60),
                        child: Text(
                          '立即扫码加入',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xFF2F3B53)),
                        )),
                    Positioned(
                        top: ScreenUtil().setWidth(67),
                        left: ScreenUtil().setWidth(212),
                        child: Image.asset(
                          'images/decorate_left.png',
                          width: ScreenUtil().setWidth(20),
                        )),
                    Positioned(
                        top: ScreenUtil().setWidth(67),
                        right: ScreenUtil().setWidth(212),
                        child: Image.asset(
                          'images/decorate_right.png',
                          width: ScreenUtil().setWidth(20),
                        )),
                    Positioned(
                        top: ScreenUtil().setWidth(122),
                        child: QrImage(
//                          data: '${circleDb != null ? circleDb.toJson() : ''}',
                          data:
                              '${circleDb != null ? jsonEncode(circleDb) : ''}',
                          size: ScreenUtil().setWidth(500),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                child: DeleteButton(circleDb != null ? !circleDb.isDefault : false, () {
                  showQuitDialog(context);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showQuitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确定删除此圈子？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确认'),
              onPressed: () {
                CircleDbProvider.circleDbProvider.deleteCircle(circleDb);
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 20,
          // 设置成 圆角
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
    );
  }

  void quit() {}

  Future<void> getData() async {
    CircleDb circleDb = await CircleDbProvider.circleDbProvider
        .getCircle(widget.chainId, widget.walletAddress);
    setState(() {
      this.circleDb = circleDb;
    });
  }
}

class DeleteButton extends StatelessWidget {
  bool isShow;

  Function callBack;

  DeleteButton(this.isShow, this.callBack);

  @override
  Widget build(BuildContext context) {
    if (isShow) {
      return CommonButton(
        '删除圈子',
        () {
          callBack();
        },
        color: Color(0xFFF2453C),
        width: ScreenUtil().setWidth(670),
        height: ScreenUtil().setWidth(96),
      );
    } else {
      return Container();
    }
  }
}
