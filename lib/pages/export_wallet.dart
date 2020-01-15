import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/widgets/common_button.dart';

///导出钱包
class ExportWallet extends StatelessWidget {
  String keyStore;

  ExportWallet(this.keyStore);

  @override
  Widget build(BuildContext context) {
    return MyTabBar(keyStore);
  }
}

class MyTabBar extends StatefulWidget {
  String keyStore;

  MyTabBar(this.keyStore);

  @override
  State<StatefulWidget> createState() {
    return TabBarState();
  }
}

class TabBarState extends State<MyTabBar> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: ScreenUtil().setWidth(50),
          color: Color(0xFFB5BFCB),
          onPressed: () {
            Application.router.pop(context);
          },
        ),
        bottom: TabBar(
          tabs: <Widget>[
            new Tab(
              child: Text(
                '离线保存',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32), color: Color(0xFF708093)),
              ),
            ),
            new Tab(
                child: Text(
              '二维码',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(32), color: Color(0xFF708093)),
            )),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          OffLineSave(widget.keyStore),
          QRCode(widget.keyStore),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class OffLineSave extends StatelessWidget {
  String keyStore;

  OffLineSave(this.keyStore);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(1100),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  child: Text(
                    '请复制粘贴keystore文件到安全、离线的地方保存。切勿保存在邮箱、记事本、网盘、聊天工具等地方，风险极高',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xFF95A2B3)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(146),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  child: Text(
                    '请勿使用网络传输',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xFF2F3B53)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(216),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  child: Text(
                    '请勿通过网络工具传输keystore文件，一旦被黑客截获将造成不可挽回的资产损失。建议离线或通过扫二维码方式传输',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xFF95A2B3)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(322),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  child: Text(
                    '高级保存',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        color: Color(0xFF2F3B53)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(392),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  child: Text(
                    '请使用您信赖的其它安全等级较高的密码保管软件保存keystore',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xFF95A2B3)),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(455),
                  left: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40),
                  child: Container(
                    color: Color(0xFFF7F7FA),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                    width: ScreenUtil().setWidth(670),
                    child: Text(
                      keyStore,
                      style: TextStyle(),
                    ),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(960),
                  child: CommonButton(
                    '复制keystore',
                    () {
                      Clipboard.setData(ClipboardData(text: keyStore));
                      Fluttertoast.showToast(msg: '复制成功');
                    },
                    width: ScreenUtil().setWidth(670),
                    height: ScreenUtil().setWidth(96),
                    color: Color(0xFF616EE3),
                  ))
            ],
          ),
        )
      ],
    ));
  }
}

class QRCode extends StatelessWidget {
  String keyStore;

  QRCode(this.keyStore);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(70),
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40),
            ),
            child: Text(
              '仅供直接扫码',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(36),
                  color: Color(0xFF2F3B53),
                  fontWeight: FontWeight.w600),
            )),
        Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40),
            ),
            child: Text(
              '二维码禁止保存、截图、以及拍照。仅供用户在安全环境下直接扫码来方便的导入钱包',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(24), color: Color(0xFF95A2B3)),
            )),
        Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(40),
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40),
            ),
            child: Text(
              '确保安全',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(36),
                  color: Color(0xFF2F3B53),
                  fontWeight: FontWeight.w600),
            )),
        Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(20),
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40),
            ),
            child: Text(
              '请确保四周无人及无摄相头，二维码一旦被他人获取将造成不可挽回的资产损失',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(24), color: Color(0xFF95A2B3)),
            )),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(40),
          ),
          child: Container(
              height: ScreenUtil().setWidth(660),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                      top: ScreenUtil().setWidth(26),
                      left: ScreenUtil().setWidth(40),
                      child: Container(
                        width: ScreenUtil().setWidth(670),
                        height: ScreenUtil().setWidth(620),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(174, 179, 208, 0.2),
                                blurRadius: 16)
                          ],
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(12)),
                        ),
                      )),
                  Positioned(
                      width: ScreenUtil().setWidth(228),
                      height: ScreenUtil().setWidth(60),
                      top: ScreenUtil().setWidth(20),
                      child: Image.asset('images/tag_code.png')),
                  Positioned(
                      top: ScreenUtil().setWidth(29),
                      child: Text(
                        '请扫码',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.white),
                      )),
                  Positioned(
                      width: ScreenUtil().setWidth(500),
                      height: ScreenUtil().setWidth(500),
                      top: ScreenUtil().setWidth(120),
                      child: QrImage(data: keyStore)),
                ],
              )),
        ),
      ],
    ));
  }
}
