import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/native_communication.dart';

///备份助记词
class BackupMnemonicWordPage extends StatelessWidget {
  String walletName;
  String walletPassword;

  BackupMnemonicWordPage(this.walletName, this.walletPassword);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFFFFFF),
        height: ScreenUtil.screenHeight,
        width: ScreenUtil.screenWidth,
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
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(30),
                    left: ScreenUtil().setWidth(40)),
                child: Text(
                  '备份助记词',
                  style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                )),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
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
                      '请按顺序抄写下方的单词，我们将在下一步进行验证请不要使用截图的方式保存或传递助记词！',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          color: Color(0xFF95A2B3)),
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ),
            MnemonicWord(walletName, walletPassword),
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(230),
                  top: ScreenUtil().setWidth(180)),
              width: ScreenUtil().setWidth(290),
              height: ScreenUtil().setWidth(96),
              child: FlatButton(
                onPressed: () {
                  Application.router.navigateTo(context,
                      '/affirmMnemonicWord?name=${Uri.encodeComponent(walletName)}&password=${Uri.encodeComponent(walletPassword)}');
                },
                child: Text('下一步',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(32),
                        fontWeight: FontWeight.normal)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(50)))),
                color: Color(0xFF616EE3),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MnemonicWord extends StatefulWidget {
  String walletName;
  String walletPassword;
  List<String> wordList;

  MnemonicWord(this.walletName, this.walletPassword);

  @override
  State<StatefulWidget> createState() {
    return MnemonicWordState();
  }
}

class MnemonicWordState extends State<MnemonicWord> {
  @override
  void initState() {
    super.initState();
    getMnemonicWords();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(500),
      width: ScreenUtil().setWidth(670),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(40),
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ScreenUtil().setWidth(12)),
          ),
        ),
      ),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: ScreenUtil().setWidth(4),
            crossAxisSpacing: ScreenUtil().setWidth(4),
            childAspectRatio: 2.25),
        itemCount: widget.wordList == null ? 0 : widget.wordList.length,
        itemBuilder: (BuildContext context, int position) {
          return ItemView(widget.wordList, position);
        },
      ),
    );
  }

  Future getMnemonicWords() async {
    print('getMnemonicWords widget.walletPassword ${widget.walletPassword}');

    ///添加助记词
    WalletDbProvider walletDbProvider = WalletDbProvider();
    Wallet wallet = await walletDbProvider.getWallet(widget.walletName);

    wallet.generatePrivateKey();
    List<dynamic> array = jsonDecode(wallet.privateKey);

    ///生成助记词
    String mnemonicWordsString = await NativeCommunication.getMnemonicWords(
        widget.walletPassword, array[3]);

    print('getMnemonicWords widget.walletName ${widget.walletName}');

    wallet.mnemonicWord = mnemonicWordsString;
    walletDbProvider.update(wallet);

    List<String> mnemonicWords = mnemonicWordsString.split(' ');

    print('mnemonicWords $mnemonicWords');
    setState(() {
      widget.wordList = mnemonicWords;
    });
  }
}

class ItemView extends StatelessWidget {
  List<String> list;
  int position;

  ItemView(this.list, this.position) {}

  @override
  Widget build(BuildContext context) {
    int i = position + 1;
    return Container(
      width: ScreenUtil().setWidth(223),
      height: ScreenUtil().setWidth(99),
      color: Color(0xFFF7F7FA),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: ScreenUtil().setWidth(20),
            top: ScreenUtil().setWidth(8),
            child: Text(
              '$i',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20), color: Color(0xFFB5BFCB)),
            ),
          ),
          Positioned(
              width: ScreenUtil().setWidth(223),
              top: ScreenUtil().setWidth(27),
              child: Text(
                list[position],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ScreenUtil().setSp(32)),
              ))
        ],
      ),
    );
  }
}
