import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/widgets/character_visible.dart';
import 'package:wallet/widgets/loading_dialog.dart';

class CreateWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CreateWalletPageView();
  }
}

class CreateWalletPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateWalletPageState();
  }
}

///创建钱包
//class CreateWalletPage extends StatelessWidget {
class CreateWalletPageState extends State<CreateWalletPageView> {
  String walletName = '';
  String password;
  String passwordConfirm = '';
  String passwordNotice = '';
  String userName = '';
  bool isAgree;

  bool createEnable = false;

  ///创建按钮是否可以点击

  TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    textEditingController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(64)),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: ScreenUtil().setWidth(50),
                  color: Color(0xFFB5BFCB),
                  onPressed: () {
                    Application.router.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(40)),
                child: Text(
                  '创建钱包',
                  style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(8)),
                      child: Icon(
                        Icons.error_outline,
                        size: ScreenUtil().setWidth(22),
                        color: Color(0xFFF2453C),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                      width: ScreenUtil().setWidth(640),
                      alignment: Alignment.center,
                      child: Text(
                        '密码用于加密保护私钥，以及交易授权等操作。BOX不会以任何方式存储用户密码，也无法帮您找回请务必牢记您的密码',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xFF95A2B3)),
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(72)),
                child: Text(
                  '钱包名称',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xFF2F3B53)),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(670),
                height: ScreenUtil().setWidth(84),
                color: Color(0xFFF7F7FA),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(15)),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30)),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      walletName = text;
                    });
                  },
                  maxLength: 12,
                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                  decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: '最多12个字符'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(40)),
                child: Text(
                  '密码',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xFF2F3B53)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                child: Container(
                    width: ScreenUtil().setWidth(670),
                    height: ScreenUtil().setWidth(84),
                    color: Color(0xFFF7F7FA),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(39),
                        top: ScreenUtil().setWidth(15)),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                    ),
                    child: InputBox(true, '8-20位，支持数字和大小写字母', (String text) {
                      setState(() {
                        password = text;
                      });
                    })),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(40)),
                child: Text(
                  '确认密码',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xFF2F3B53)),
                ),
              ),
              Container(
                  width: ScreenUtil().setWidth(670),
                  height: ScreenUtil().setWidth(84),
                  color: Color(0xFFF7F7FA),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(39),
                      top: ScreenUtil().setWidth(15)),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: InputBox(true, '请再次输入密码', (String text) {
                    setState(() {
                      passwordConfirm = text;
                    });
                  })),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(40)),
                child: Text(
                  '密码提示信息',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xFF2F3B53)),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(670),
                height: ScreenUtil().setWidth(84),
                color: Color(0xFFF7F7FA),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(15)),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30)),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      passwordNotice = text;
                    });
                  },
                  maxLength: 20,
                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                  decoration: InputDecoration(
                    hintText: '选填，最多20个字符',
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(39),
                    top: ScreenUtil().setWidth(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AgreeRadio((isAgree) {
                      setState(() {
                        this.isAgree = isAgree;
                      });
                    }),
                    Text(
                      '我已阅读并同意',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                          color: Color(0xFFB5BFCB)),
                      softWrap: true,
                    ),
                    GestureDetector(
                      child: Text(
                        '《服务及隐私条款》',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            color: Color(0xFF616EE3)),
                        softWrap: true,
                      ),
                      onTap: () {
                        String url = NetUtils.host + '/tos';
                        Application.router.navigateTo(
                            context, '/web?url=${Uri.encodeComponent(url)}');
                      },
                    ),
                  ],
                ),
              ),
              ConfirmButton(true, () {
                if (checkInput()) {
                  createWallet();
                }
              })
            ],
          ),
        ));
  }

//  void checkInput() {
//    setState(() {
//      createEnable = walletName.isNotEmpty &&
//          password.isNotEmpty &&
//          password.length >= 8 &&
//          password.length <= 20 &&
//          passwordConfirm.isNotEmpty &&
//          password == passwordConfirm &&
//          isAgree;
//    });
//    if(walletName.isEmpty){
//      Fluttertoast.showToast(msg: '请输入名称');
//    } else {
//
//    }
//  }

  bool checkInput() {
    if (walletName.trim().isEmpty) {
      Fluttertoast.showToast(msg: '请输入名称');
      return false;
    } else if (password == null ||
        password.isEmpty ||
        password.length < 8 ||
        password.length > 20) {
      Fluttertoast.showToast(msg: '密码格式不正确');
      return false;
    } else if (passwordConfirm.isEmpty || password != passwordConfirm) {
      Fluttertoast.showToast(msg: '两次密码不一样');
      return false;
    } else if (isAgree == null || !isAgree) {
      Fluttertoast.showToast(msg: '请同意协议');
      return false;
    } else {
      return true;
    }
  }

  Future createWallet() async {
    LoadingDialog.showLoading(context);
    WalletDbProvider walletDbProvider = WalletDbProvider();

    if (!await checkRepetition(walletDbProvider)) {
      Wallet wallet = Wallet(
          name: walletName,
          password: password,
          notice: passwordNotice,
          mnemonicWord: '');
      await walletDbProvider.insert(wallet);

      LoadingDialog.hideLoading(context);

      Application.router.navigateTo(context,
          '/backupWallet?name=${Uri.encodeComponent(walletName)}&password=${Uri.encodeComponent(password)}');
    } else {
      LoadingDialog.hideLoading(context);
    }
  }

  ///检查重复
  Future<bool> checkRepetition(WalletDbProvider walletDbProvider) async {
    Wallet wallet = await walletDbProvider.getWallet(walletName);

    if (wallet != null) {
      Fluttertoast.showToast(msg: '钱包名称已存在');
      return true;
    } else {
      return false;
    }
  }
}

//同意条款
class AgreeRadio extends StatefulWidget {
  ValueChanged callBack;

  AgreeRadio(this.callBack);

  @override
  State<StatefulWidget> createState() {
    return _AgreeRadioState();
  }
}

class _AgreeRadioState extends State<AgreeRadio> {
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

///创建钱包按钮
class ConfirmButton extends StatefulWidget {
  bool enable = false; //是否可以点击
  Function callback;

  ConfirmButton(this.enable, this.callback);

  @override
  State<StatefulWidget> createState() {
    return _ConfirmButtonState();
  }
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(97),
          top: ScreenUtil().setWidth(50),
          bottom: ScreenUtil().setWidth(50)),
      width: ScreenUtil().setWidth(556),
      height: ScreenUtil().setWidth(96),
      child: FlatButton(
        onPressed: () {
          if (widget.enable) {
            widget.callback();
          }
        },
        child: Text('创建钱包',
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(32),
                fontWeight: FontWeight.normal)),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(50)))),
        color: widget.enable ? Color(0xFF616EE3) : Color(0xFFD6DDE6),
      ),
    );
  }
}

class InputBox extends StatefulWidget {
  bool visible = false; //文字是否可见
  String hint;
  Function function;
  String text;

  InputBox(this.visible, this.hint, this.function);

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
