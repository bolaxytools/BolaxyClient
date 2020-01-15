import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/native_communication.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/widgets/common_button.dart';
import 'package:wallet/widgets/input_box.dart';
import 'package:wallet/widgets/notice_success_dialog.dart';

///导入钱包
class ImportWalletPage extends StatelessWidget {
  TabController mController;

  @override
  Widget build(BuildContext context) {
    return MyTabBar();
  }
}

class MyTabBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TabBarState();
  }
}

class TabBarState extends State<MyTabBar> with SingleTickerProviderStateMixin {
  TabController tabController;
  Keystore keystore;

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
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                scanKeystore();
              },
              child: Image.asset(
                'images/scan.png',
                width: ScreenUtil().setWidth(35),
                height: ScreenUtil().setWidth(35),
              ))
        ],
        bottom: TabBar(
          tabs: <Widget>[
            new Tab(
              child: Text(
                '助记词',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32), color: Color(0xFF708093)),
              ),
            ),
            new Tab(
                child: Text(
              'keystore',
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
          BackupWord(),
          keystore = Keystore(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  void scanKeystore() {
    requestPermission();
  }

  Future scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      print('扫码结果: ' + barcode);
      manageResult(barcode);
    } on PlatformException catch (e) {
      print('扫码错误: e.code ${e.code}');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }

  Future requestPermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    // 申请结果
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.granted) {
      if (tabController.index != 1) {
        setState(() {
          tabController.index = 1;
        });
      }
      scan();
    } else {
      Fluttertoast.showToast(msg: "权限申请被拒绝");
    }
  }

  void manageResult(String result) {
    keystore.setKeystore(result);
  }
}

class BaseImportPage<T extends StatefulWidget> extends State {
  String backupWord;
  String name;
  String password;
  String passwordAffirm;
  String notice = '';
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return null;
  }

  bool checkInput() {
    if (backupWord == null) {
      Fluttertoast.showToast(msg: '助记词有错误');
      return false;
    } else if (name == null || name.trim().isEmpty) {
      Fluttertoast.showToast(msg: '钱包名称有错误');
      return false;
    } else if (password == null ||
        password.length < 8 ||
        password.length > 20) {
      Fluttertoast.showToast(msg: '密码不符合要求');
      return false;
    } else if (password != passwordAffirm) {
      Fluttertoast.showToast(msg: '两次密码不相同');
      return false;
    } else if (!isAgree) {
      Fluttertoast.showToast(msg: '请同意条款');
      return false;
    } else {
      List<String> backupWords = backupWord.split(' ');
      if (backupWords == null || backupWords.length != 12) {
        Fluttertoast.showToast(msg: '助记词有错误');
        return false;
      }
    }

    return true;
  }

  void import(BuildContext context) {
    if (checkInput()) {
      createWallet(context);
    }
  }

  Future createWallet(BuildContext context) async {}
}

///助记词
class BackupWord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BackupWordState();
  }
}

class BackupWordState extends BaseImportPage<BackupWord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(670),
              height: ScreenUtil().setWidth(255),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(20)),
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              color: Color(0xFFF7F7FA),
              child: TextField(
                  onChanged: (text) {
                    backupWord = text;
//                    checkInput();
                  },
                  maxLines: 10,
                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                  decoration: InputDecoration(
                      hintText: '请输入助记词，相邻用空格分隔',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFB5BFCB)))),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '钱包名称',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setWidth(4)),
              child: TextField(
                onChanged: (text) {
                  name = text;
//                  checkInput();
                },
                style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                maxLength: 12,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '最多12个字符',
                    contentPadding: EdgeInsets.only(
                      top: ScreenUtil().setSp(30),
                    ),
                    hintStyle: TextStyle(color: Color(0xFFB5BFCB))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '密码',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                ),
                child: InputBox(false, '8-20位，支持数字和大小写字母', (text) {
                  password = text;
                })),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '确认密码',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                ),
                child: InputBox(false, '请再次输入密码', (text) {
                  passwordAffirm = text;
                })),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '密码提示信息',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                  notice = text;
//                  checkInput();
                },
                style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '选填，最多20个字符',
                    hintStyle: TextStyle(color: Color(0xFFB5BFCB))),
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
                    this.isAgree = isAgree;
//                    checkInput();
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
                      Application.router.navigateTo(context,
                          '/web?url=${Uri.encodeComponent(NetUtils.host + '/tos')}');
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40),
                ),
                child: CommonButton(
                  '确定导入',
                  () {
                    import(context);
                  },
                  color: Color(0xFF616EE3),
                  width: ScreenUtil().setWidth(670),
                  height: ScreenUtil().setWidth(96),
                )),
          ],
        ),
      ),
    );
  }

  Future createWallet(BuildContext context) async {
    if (await NativeCommunication.checkMnemonic(backupWord)) {
      WalletDbProvider walletDbProvider = WalletDbProvider();
      if (await walletDbProvider.checkMnemonicWordRepetition(
          backupWord, password)) {
        Fluttertoast.showToast(msg: '钱包已导入');
      } else if (await walletDbProvider.checkNameRepetition(name)) {
        Fluttertoast.showToast(msg: '钱包名称已存在');
      } else {
        Wallet wallet = Wallet(
            name: name,
            password: password,
            notice: notice,
            mnemonicWord: backupWord);
        wallet.isBackup = true;
        wallet = await wallet.generatePrivateKeyWithMnemonic();
        walletDbProvider.insert(wallet);
        Application.router.navigateTo(context, '/bottomNavigation');
        NoticeDialog.showNoticeDialog(
            context, '导入成功', NoticeDialog.successImagePath);
      }
    } else {
      Fluttertoast.showToast(msg: '助记词不合法');
    }
  }
}

class Keystore extends StatefulWidget {
  KeystoreState keystoreState;

  @override
  State<StatefulWidget> createState() {
    return keystoreState = KeystoreState();
  }

  void setKeystore(String keystore) {
    keystoreState.setKeystore(keystore);
  }
}

class KeystoreState extends BaseImportPage<Keystore> {
  String keystore;

  TextEditingController controller = TextEditingController();

  void setKeystore(String keystore) {
    this.keystore = keystore;
    setState(() {
      controller.text = keystore;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40),
                  right: ScreenUtil().setWidth(40)),
              child: Text(
                '请粘帖Keystore文本内容，或扫描Keystore生成的二维码，完成录入',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24), color: Color(0xFF95A2B3)),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(670),
              height: ScreenUtil().setWidth(255),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30)),
              color: Color(0xFFF7F7FA),
              child: TextField(
                  controller: controller,
                  maxLines: 10,
                  onChanged: (text) {
                    keystore = text;
//                    checkInput();
                  },
                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                  decoration: InputDecoration(
                      hintText: '粘贴keystore内容',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFB5BFCB)))),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '钱包名称',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                  right: ScreenUtil().setWidth(10),
                  bottom: ScreenUtil().setWidth(4)),
              child: TextField(
                onChanged: (text) {
                  name = text;
//                  checkInput();
                },
                style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                maxLength: 12,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '最多12个字符',
                    contentPadding: EdgeInsets.only(
                      top: ScreenUtil().setSp(30),
                    ),
                    hintStyle: TextStyle(color: Color(0xFFB5BFCB))),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '密码',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                child: InputBox(
                  true,
                  '8-20位，支持数字和大小写字母',
                  (text) {
                    password = text;
                  },
                  hintColor: 0xFFB5BFCB,
                )),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '确认密码',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                child: InputBox(
                  true,
                  '请再次输入密码',
                  (text) {
                    passwordAffirm = text;
                  },
                  hintColor: 0xFFB5BFCB,
                )),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(40)),
              child: Text(
                '密码提示信息',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
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
                  notice = text;
//                  checkInput();
                },
                style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '选填，最多20个字符',
                    hintStyle: TextStyle(color: Color(0xFFB5BFCB))),
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
                    this.isAgree = isAgree;
//                    checkInput();
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
                      Application.router.navigateTo(context,
                          '/web?url=${Uri.encodeComponent(NetUtils.host + '/tos')}');
                    },
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(40),
                  left: ScreenUtil().setWidth(40),
                ),
                child: CommonButton(
                  '确定导入',
                  () {
                    import(context);
                  },
                  color: Color(0xFF616EE3),
                  width: ScreenUtil().setWidth(670),
                  height: ScreenUtil().setWidth(96),
                )),
          ],
        )));
  }

  bool checkInput() {
    if (keystore == null) {
      Fluttertoast.showToast(msg: 'keystore有错误');
    } else if (name == null || name.trim().isEmpty) {
      Fluttertoast.showToast(msg: '钱包名称有错误');
      return false;
    } else if (password == null ||
        password.length < 8 ||
        password.length > 20) {
      Fluttertoast.showToast(msg: '密码不符合要求');
      return false;
    } else if (password != passwordAffirm) {
      Fluttertoast.showToast(msg: '两次密码不相同');
      return false;
    } else if (!isAgree) {
      Fluttertoast.showToast(msg: '请同意条款');
      return false;
    }

    return true;
  }

  Future createWallet(BuildContext context) async {
    WalletDbProvider walletDbProvider = WalletDbProvider();
    print('createWallet name $name');
    if (await walletDbProvider.checkNameRepetition(name)) {
      print('createWallet checkNameRepetition');
      Fluttertoast.showToast(msg: '钱包名称已存在');
    } else if (await walletDbProvider.checkKeyStoreRepetition(keystore)) {
      Fluttertoast.showToast(msg: '钱包已导入');
    } else {
      Wallet wallet = Wallet(name: name, password: password, notice: notice);
      wallet.keyStore = keystore;
      wallet.isBackup = true;
      await wallet.generatePrivateKeyWithKeyStore();
      if(wallet.address != null && wallet.address.isNotEmpty){
        walletDbProvider.insert(wallet);

        NoticeDialog.showNoticeDialog(
            context, '导入成功', NoticeDialog.successImagePath,callback: (){
          Application.router.navigateTo(context, '/bottomNavigation');
        });
      }
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
