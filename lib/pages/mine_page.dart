import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/widgets/notice_success_dialog.dart';
import 'package:wallet/widgets/open_fingerprint_dialog.dart';
import 'package:wallet/widgets/switch_circle_dialog.dart';

///我的
class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<MinePage> {
  CircleDb circleDb;

  SelectLanguage selectLanguage;

  bool isShowLangSelect = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: ScreenUtil().setWidth(70),
            left: ScreenUtil().setWidth(40),
            child: Row(
              children: <Widget>[
                Text(
                  circleDb != null ? circleDb.name : '',
                  style: TextStyle(
                      fontSize: ScreenUtil().setWidth(48),
                      color: Color(0xFF2F3B53)),
                ),
                GestureDetector(
                  onTap: () {
                    SwitchCircleDialog.showSwitchCircle(context,
                        callback: (isRefresh) {
                      if (isRefresh) {
                        getData();
                      }
                    });
                  },
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: ScreenUtil().setWidth(50),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: ScreenUtil().setWidth(40),
              top: ScreenUtil().setWidth(207),
              child: Container(
                  width: ScreenUtil().setWidth(214),
                  height: ScreenUtil().setWidth(230),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(174, 179, 208, 0.2),
                          blurRadius: ScreenUtil().setWidth(30),
                          offset: Offset(0, ScreenUtil().setWidth(5)))
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(16)),
                  ),
                  child: FlatButton(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                            top: ScreenUtil().setWidth(57),
                            child: Image.asset(
                              'images/code_mine.png',
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setWidth(50),
                            )),
                        Positioned(
                            top: ScreenUtil().setWidth(146),
                            child: Text(
                              '我的二维码',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Color(0xFF2F3B53)),
                            ))
                      ],
                    ),
                    onPressed: () {
                      Application.router.navigateTo(context, '/gathering');
                    },
                  ))),
          Positioned(
              left: ScreenUtil().setWidth(268),
              top: ScreenUtil().setWidth(207),
              child: Container(
                  width: ScreenUtil().setWidth(214),
                  height: ScreenUtil().setWidth(230),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(174, 179, 208, 0.2),
                          blurRadius: ScreenUtil().setWidth(30),
                          offset: Offset(0, ScreenUtil().setWidth(5)))
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(16)),
                  ),
                  child: FlatButton(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                            top: ScreenUtil().setWidth(57),
                            child: Image.asset(
                              'images/circle_mine.png',
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setWidth(50),
                            )),
                        Positioned(
                            top: ScreenUtil().setWidth(146),
                            child: Text(
                              '圈子设置',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Color(0xFF2F3B53)),
                            ))
                      ],
                    ),
                    onPressed: () {
                      Application.router.navigateTo(context, '/circleSetting');
                    },
                  ))),
          Positioned(
              left: ScreenUtil().setWidth(496),
              top: ScreenUtil().setWidth(207),
              child: Container(
                  width: ScreenUtil().setWidth(214),
                  height: ScreenUtil().setWidth(230),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(174, 179, 208, 0.2),
                          blurRadius: ScreenUtil().setWidth(30),
                          offset: Offset(0, ScreenUtil().setWidth(5)))
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(16)),
                  ),
                  child: FlatButton(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Positioned(
                            top: ScreenUtil().setWidth(57),
                            child: Image.asset(
                              'images/wallet_mine.png',
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setWidth(50),
                            )),
                        Positioned(
                            top: ScreenUtil().setWidth(146),
                            child: Text(
                              '管理钱包',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: Color(0xFF2F3B53)),
                            ))
                      ],
                    ),
                    onPressed: () {
                      Application.router.navigateTo(context, '/manageWallet');
                    },
                  ))),
          Positioned(
              top: ScreenUtil().setWidth(507),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '基本设置',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26), color: Color(0xFFB5BFCB)),
              )),
          Positioned(
              width: ScreenUtil.screenWidthDp,
              top: ScreenUtil().setWidth(556),
              height: ScreenUtil().setWidth(80),
              child: FlatButton(
                  onPressed: () {
                    changeLanguage();
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                        child: Text(
                          '显示语言',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xFF2F3B53)),
                        ),
                      ),
                    ],
                  ))),
          Positioned(
              top: ScreenUtil().setWidth(576),
              right: ScreenUtil().setWidth(40),
              child: Language()),
//          Positioned(
//              top: ScreenUtil().setWidth(664),
//              left: ScreenUtil().setWidth(40),
//              child: Text(
//                '声音',
//                style: TextStyle(
//                    fontSize: ScreenUtil().setSp(30), color: Color(0xFF2F3B53)),
//              )),
//          Positioned(
//              top: ScreenUtil().setWidth(645),
//              right: ScreenUtil().setWidth(40),
//              child: VoiceSwitch((isOpen){
//
//              })),
          Positioned(
              top: ScreenUtil().setWidth(664),
//              top: ScreenUtil().setWidth(756),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '清除缓存',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: Color(0xFF2F3B53)),
              )),
          Positioned(
              top: ScreenUtil().setWidth(665),
//              top: ScreenUtil().setWidth(757),
              right: ScreenUtil().setWidth(40),
              child: Cache()),
          Positioned(
              top: ScreenUtil().setWidth(878 - 90),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '安全中心',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26), color: Color(0xFFB5BFCB)),
              )),
          Positioned(
              top: ScreenUtil().setWidth(945 - 90),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '开启指纹验证',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: Color(0xFF2F3B53)),
              )),
          Positioned(
              top: ScreenUtil().setWidth(925 - 90),
              right: ScreenUtil().setWidth(40),
              child: VoiceSwitch((isOpen) {
                if (isOpen) {
                  OpenFingerprintDialog.showOpenFingerprintDialog(context);
                }
              })),
          Positioned(top: 0, left: 0, child: SelectLanguage(isShowLangSelect))
        ],
      ),
    );
  }

  ///清除缓存
  void cleanCache(BuildContext context) {
    NoticeDialog.showNoticeDialog(
        context, '缓存已清空', NoticeDialog.successImagePath);
  }

  Future<void> getData() async {
    print('getData ');
    Wallet wallet = await WalletDbProvider.walletDbProvider.getCurrentWallet();

    CircleDb circleDb = await CircleDbProvider.circleDbProvider
        .getCircle(wallet.circleChainId, wallet.address);

    setState(() {
      this.circleDb = circleDb;
    });
  }

  void changeLanguage() {
    setState(() {
      isShowLangSelect = true;
    });
  }
}

class Language extends StatefulWidget {
  String language = '简体中文';

  @override
  State<StatefulWidget> createState() {
    return LanguageState();
  }
}

class LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          widget.language,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28), color: Color(0xFF95A2B3)),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: ScreenUtil().setWidth(30),
          color: Color(0xFF95A2B3),
        )
      ],
    );
  }
}

///声音开关
class VoiceSwitch extends StatefulWidget {
  bool isOpen = true;
  ValueChanged callBack;

  VoiceSwitch(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return VoiceSwitchState();
  }
}

class VoiceSwitchState extends State<VoiceSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: widget.isOpen,
        onChanged: (bool v) {
          setState(() {
            widget.isOpen = v;
            widget.callBack(widget.isOpen);
          });
        });
  }
}

///缓存
class Cache extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CacheState();
  }
}

class CacheState extends State<Cache> {
  @override
  Widget build(BuildContext context) {
    return Text(
      '3.89M',
      style:
          TextStyle(fontSize: ScreenUtil().setSp(28), color: Color(0xFF95A2B3)),
    );
  }
}

///选择语言
class SelectLanguage extends StatefulWidget {
  bool showSelect = false;
  int selectIndex = 1;

  SelectLanguageState selectLanguageState;

  SelectLanguage(this.showSelect);

  @override
  State<StatefulWidget> createState() {
    return SelectLanguageState();
  }

}

class SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    if (widget.showSelect) {
      return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil.screenHeight,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: ScreenUtil().setWidth(40),
                left: ScreenUtil().setWidth(20),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: ScreenUtil().setWidth(50),
                  color: Color(0xFFB5BFCB),
                  onPressed: () {
                    setState(() {
                      widget.showSelect = false;
                    });
                  },
                )),
            Positioned(
                top: ScreenUtil().setWidth(150),
                left: ScreenUtil().setWidth(40),
                child: Text(
                  '显示语言',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(48),
                      color: Color(0xFF2F3B53),
                      fontWeight: FontWeight.w500),
                )),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(268),
                  left: ScreenUtil().setWidth(20)),
              child: CheckboxListTile(
                  secondary: Image.asset(
                    'images/china.png',
                    width: ScreenUtil().setWidth(35),
                    height: ScreenUtil().setWidth(35),
                  ),
                  title: Text(
                    '简体中文',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xFF2F3B53)),
                  ),
                  value: 1 == widget.selectIndex,
                  onChanged: (bool value) {
                    setState(() {
                      widget.selectIndex = 1;
                    });
                  }),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(360),
                  left: ScreenUtil().setWidth(20)),
              child: CheckboxListTile(
                  secondary: Image.asset(
                    'images/american.png',
                    width: ScreenUtil().setWidth(35),
                    height: ScreenUtil().setWidth(35),
                  ),
                  title: Text(
                    'English',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xFF2F3B53)),
                  ),
                  value: 2 == widget.selectIndex,
                  onChanged: (bool value) {
                    setState(() {
                      widget.selectIndex = 2;
                    });
                  }),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}

class LanguageRadio extends StatefulWidget {
  ValueChanged callBack;

  LanguageRadio(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return LanguageRadioState();
  }
}

class LanguageRadioState extends State<LanguageRadio> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: isAgree,
        onChanged: (value) {
          setState(() {
            isAgree = value;
            widget.callBack(isAgree);
          });
        });
  }
}
