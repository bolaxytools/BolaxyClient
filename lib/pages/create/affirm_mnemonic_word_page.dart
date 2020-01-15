import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/widgets/backup_success_dialog.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/widgets/notice_success_dialog.dart';

///确认助记词
class AffirmMnemonicWordPage extends StatelessWidget {
  String walletName;
  String walletPassword;
  WordSelectChip wordSelectChip;

  AffirmMnemonicWordPage(this.walletName, this.walletPassword);

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
                  top: ScreenUtil().setWidth(70)),
              child: Text(
                '请按顺序点击助记词，以确认你的备份助记词正确',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24), color: Color(0xFF95A2B3)),
                softWrap: true,
              ),
            ),
            wordSelectChip = WordSelectChip(walletName, walletPassword),
            Container(
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(40),
                  top: ScreenUtil().setWidth(160)),
              width: ScreenUtil().setWidth(670),
              height: ScreenUtil().setWidth(96),
              child: FlatButton(
                onPressed: () {
                  inputComplete(context);
                },
                child: Text('确认',
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

  ///输入完成
  void inputComplete(BuildContext context) {
    if (wordSelectChip.compare()) {
      setBackup();
      NoticeDialog.showNoticeDialog(
          context, '备份成功', NoticeDialog.successImagePath, callback: () {
        Application.router.navigateTo(context, '/bottomNavigation');
      });
    } else {
      Fluttertoast.showToast(msg: '助记词错误');
    }
  }

  Future setBackup() async {
    Wallet wallet = await WalletDbProvider.walletDbProvider.getWallet(walletName);
    wallet.isBackup = true;
    await WalletDbProvider.walletDbProvider.update(wallet);
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

class WordSelectChip extends StatefulWidget {
  String walletName;
  String walletPassword;
  List<String> wordList = List();
  List<String> randomWordList = List();
  List<String> selectWords = List();

  WordSelectChip(this.walletName, this.walletPassword);

  @override
  State<StatefulWidget> createState() {
    return WordSelectChipState();
  }

  bool compare() {
    if (selectWords.length == wordList.length) {
      for (int i = 0; i < wordList.length; i++) {
        if (selectWords[i] != wordList[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}

class WordSelectChipState extends State<WordSelectChip> {
  @override
  void initState() {
    super.initState();
    getMnemonicWords();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(670),
          height: ScreenUtil().setWidth(270),
          margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(30), left: ScreenUtil().setWidth(40)),
          color: Color(0xFFF7F7FA),
          child: ChipTheme(
              data: ChipThemeData(
                backgroundColor: Colors.transparent,
                disabledColor: Colors.transparent,
                selectedColor: Colors.transparent,
                secondarySelectedColor: Colors.black,
                labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.only(),
                shape: Border(),
                labelStyle: TextStyle(
                    color: Color(0xFF2F3B53), fontSize: ScreenUtil().setSp(32)),
                secondaryLabelStyle: TextStyle(color: Colors.white),
                brightness: Brightness.light,
                elevation: 0,
              ),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 0,
                children: <Widget>[
                  for (String item in widget.selectWords) TagItem(item)
                ],
              )),
        ),
        Container(
          width: ScreenUtil().setWidth(670),
          height: ScreenUtil().setHeight(300),
//          height: ScreenUtil().setHeight(255),
          margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(30), left: ScreenUtil().setWidth(40)),
          child: ChipTheme(
              data: ChipThemeData(
                backgroundColor: Colors.transparent,
                disabledColor: Colors.transparent,
                selectedColor: Colors.white,
                secondarySelectedColor: Color(0xFFBCC3FF),
                labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(12)))),
                padding: EdgeInsets.only(),
                labelStyle: TextStyle(
                    color: Color(0xFF2F3B53), fontSize: ScreenUtil().setSp(32)),
                secondaryLabelStyle: TextStyle(
                    color: Color(0xFFF8F8F8), fontSize: ScreenUtil().setSp(32)),
                brightness: Brightness.light,
                elevation: 0,
              ),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 0,
                children: <Widget>[
                  for (int i = 0; i < widget.randomWordList.length; i++)
                    ChoiceWord(widget.randomWordList[i],
                        widget.selectWords.contains(widget.randomWordList[i]),
                        (isSelect) {
                      setState(() {
                        if (isSelect) {
                          widget.selectWords.add(widget.randomWordList[i]);
                        } else {
                          widget.selectWords.remove(widget.randomWordList[i]);
                        }
                      });
                    })
                ],
              )),
        )
      ],
    );
  }

  Future getMnemonicWords() async {
    print('getMnemonicWords wallet ${widget.walletName}');

    ///从数据库中获取助记词
    WalletDbProvider walletDbProvider = WalletDbProvider();
    Wallet wallet = await walletDbProvider.getWallet(widget.walletName);

    print('getMnemonicWords wallet ${wallet}');

    List<String> mnemonicWords = wallet.mnemonicWord.split(' ');

    setState(() {
      widget.wordList.addAll(mnemonicWords);
      widget.randomWordList = randomPermutation(mnemonicWords);
    });
  }

  ///将字符串数组随机排序
  List<String> randomPermutation(List<String> originalList) {
    List<String> result = List();
    int length = originalList.length;
    for (int i = 0; i < length; i++) {
      String element = originalList[Random().nextInt(originalList.length)];
      result.add(element);
      originalList.remove(element);
    }
    return result;
  }
}

class TagItem extends StatelessWidget {
  final String text;

  TagItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
    );
  }
}

class ChoiceWord extends StatefulWidget {
  String text;
  bool selected;
  ValueChanged callback;

  ChoiceWord(this.text, this.selected, this.callback);

  @override
  State<StatefulWidget> createState() {
    return ChoiceWordState();
  }
}

class ChoiceWordState extends State<ChoiceWord> {
  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: widget.selected,
      label: Text(widget.text),
      onSelected: (isSelect) {
        setState(() {
          widget.selected = isSelect;
        });
        widget.callback(isSelect);
      },
    );
  }
}
