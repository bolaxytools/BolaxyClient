import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/model/allow.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/widgets/common_button.dart';
import 'package:wallet/widgets/notice_success_dialog.dart';

///添加圈子
class AddCirclePage extends StatefulWidget {
  String circleString;

  AddCirclePage(this.circleString);

  @override
  State<StatefulWidget> createState() {
    return AddCirclePageState();
  }
}

class AddCirclePageState extends State<AddCirclePage> {
  CircleDb circleDb;

  @override
  void initState() {
    super.initState();
    print('initState ${widget.circleString}');
    circleDb = CircleDb.fromJson(jsonDecode(widget.circleString));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: ScreenUtil().setWidth(60),
              left: ScreenUtil().setWidth(20),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: ScreenUtil().setWidth(50),
                color: Color(0xFFB5BFCB),
                onPressed: () {
                  Application.router.pop(context);
                },
              )),
          Positioned(
              top: ScreenUtil().setWidth(150),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '添加圈子',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Color(0xFF2F3B53),
                    fontWeight: FontWeight.w500),
              )),
          Positioned(
              left: ScreenUtil().setWidth(40),
              top: ScreenUtil().setWidth(288),
              child: Container(
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
                          circleDb != null ? circleDb.name : '',
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
                          circleDb != null ? circleDb.serverPort.toString() : '',
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
              )),
          Positioned(
              top: ScreenUtil().setWidth(786),
              child: CommonButton(
                '添加圈子',
                () {
                  addCircle();
                },
                color: Color(0xFF616EE3),
                width: ScreenUtil().setWidth(670),
                height: ScreenUtil().setWidth(96),
              ))
        ],
      ),
    );
  }

  Future<void> addCircle() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String walletAddress =
        sharedPreferences.getString(SharedPreferencesUtils.sp_current_wallet);
    Allow allow = await NetUtils.checkJoin(walletAddress);
    if (allow != null && allow.allow) {
      circleDb.walletAddress = walletAddress;
      await CircleDbProvider.circleDbProvider.insert(circleDb);
      Fluttertoast.showToast(msg: '加入成功');
      Navigator.pop(context, true);
    } else {
      NoticeDialog.showNoticeDialog(
          context, '无法加入该圈子', NoticeDialog.failedImagePath);
    }
  }
}
