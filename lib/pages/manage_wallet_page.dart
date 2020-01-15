import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/routes.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/widgets/input_password_dialog.dart';

///管理钱包
class ManageWalletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ManageWalletPageState();
  }
}

class ManageWalletPageState extends State<ManageWalletPage> {
  List<Wallet> wallets;

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
              top: ScreenUtil().setWidth(50),
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
                '管理钱包',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(48),
                    color: Color(0xFF2F3B53),
                    fontWeight: FontWeight.w500),
              )),
          Positioned(
              right: ScreenUtil().setWidth(40),
              top: ScreenUtil().setWidth(80),
              child: GestureDetector(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.add,
                        size: ScreenUtil().setWidth(40),
                        color: Color(0xFFB5BFCB),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                        child: Text(
                          '创建钱包',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xFFB5BFCB)),
                        ))
                  ],
                ),
                onTap: () {
                  Application.router.navigateTo(context, Routes.createWallet);
                },
              )),
          Positioned(
              top: ScreenUtil().setWidth(278),
              left: ScreenUtil().setWidth(40),
              child: Container(
                height: ScreenUtil().setHeight(1056),
                width: ScreenUtil().setWidth(670),
                child: WalletItem(wallets, () {
                  getData();
                }),
              ))
        ],
      ),
    );
  }

  Future<void> getData() async {
    List<Wallet> wallets = await WalletDbProvider.walletDbProvider.getWallets();
    if (wallets != null && wallets.length > 0) {
      setState(() {
        this.wallets = wallets;
      });
    } else {
      Application.router.navigateTo(context, Routes.createOrImport);
    }
  }
}

class WalletItem extends StatefulWidget {
  List<Wallet> wallets;

  Function callback;

  WalletItem(this.wallets, this.callback);

  ///背景
  List<String> bgImages = [
    'images/wallet1.png',
    'images/wallet2.png',
    'images/wallet3.png',
    'images/wallet4.png',
    'images/wallet5.png'
  ];

  ///字体颜色
  List<int> textColors = [
    0xFF616EE3,
    0xFFEDC288,
    0xFF7A89BA,
    0xFF4CBBC6,
    0xFFEE6771
  ];

  @override
  State<StatefulWidget> createState() {
    return WalletItemState();
  }
}

class WalletItemState extends State<WalletItem> {
  Widget _itemBuilder(BuildContext context, int position) {
    return Container(
      width: ScreenUtil().setWidth(670),
      height: ScreenUtil().setWidth(238),
      alignment: Alignment.center,
      child: Slidable(
        key: Key('1'),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            height: ScreenUtil().setWidth(218),
            width: ScreenUtil().setWidth(670),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.bgImages[position % 5]),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter)),
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: ScreenUtil().setWidth(28),
                    left: ScreenUtil().setWidth(30),
                    child: Text(
                      widget.wallets[position].name,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Colors.white),
                    )),
                Positioned(
                    top: ScreenUtil().setWidth(82),
                    left: ScreenUtil().setWidth(30),
                    width: ScreenUtil().setWidth(500),
                    child: Text(
                      widget.wallets[position].address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Color(0x99FFFFFF)),
                    )),
                Positioned(
                    width: ScreenUtil().setWidth(175),
                    height: ScreenUtil().setWidth(56),
                    top: ScreenUtil().setWidth(137),
                    left: ScreenUtil().setWidth(30),
                    child: FlatButton(
                        color: Colors.white,
                        onPressed: () {
                          exportWallet(widget.wallets[position]);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(40)),
                        ),
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                        child: Text(
                          '导出keystore',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(22),
                              color: Color(widget.textColors[position % 5])),
                        ))),
                Positioned(
                    width: ScreenUtil().setWidth(175),
                    height: ScreenUtil().setWidth(56),
                    top: ScreenUtil().setWidth(137),
                    left: ScreenUtil().setWidth(230),
                    child:
                        ToBackUpButton(widget.wallets[position].isBackup, () {
                      InputPasswordDialog.showInputPasswordDialog(
                          context,
                          widget.wallets[position].name,
                          widget.wallets[position].password);
                    })),
                Positioned(
                    right: 0,
                    child: Container(
                      width: ScreenUtil().setWidth(152),
                      height: ScreenUtil().setWidth(55),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  widget.wallets[position].isBackup
                                      ? 'images/corner_mark.png'
                                      : 'images/corner_mark_red.png'),
                              fit: BoxFit.cover)),
                      child: FlatButton(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                          child: Text(
                            widget.wallets[position].isBackup ? '已备份' : '未备份',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(26),
                                color: widget.wallets[position].isBackup
                                    ? Color(widget.textColors[position % 5])
                                    : Colors.white),
                          )),
                    ))
              ],
            )),
        secondaryActions: <Widget>[
          Container(
            width: ScreenUtil().setWidth(180),
            height: ScreenUtil().setWidth(218),
            alignment: Alignment.center,
            child: Container(
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setWidth(100),
              child: FlatButton(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                onPressed: () {
                  deleteWallet(widget.wallets[position]);
                },
                child: Text('删除',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xFFF2453C))),
                color: Color.fromRGBO(242, 69, 60, 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(50)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget generateFooter(BuildContext context, int position) {
    return Container(
      width: ScreenUtil().setWidth(670),
      height: ScreenUtil().setWidth(96),
      margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(30), bottom: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/dashed.png'), fit: BoxFit.cover)),
      child: FlatButton(
          onPressed: () {
            Application.router.navigateTo(context, '/importWallet');
          },
          child: Text(
            '+ 导入钱包',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32), color: Color(0xFFB5BFCB)),
          )),
    );
  }

  Widget generateItem(BuildContext context, int position) {
    if (position == (widget.wallets != null ? widget.wallets.length : 0)) {
      return generateFooter(context, position);
    } else {
      return _itemBuilder(context, position);
    }
  }

  void deleteWallet(Wallet wallet) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确定删除此钱包？'),
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
                delete(wallet);
                Navigator.of(context).pop();
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

  void exportWallet(Wallet wallet) {
    Application.router
        .navigateTo(context, '/exportWallet?key_store=${wallet.keyStore}');
  }

  Future<void> delete(Wallet wallet) async {
    await WalletDbProvider.walletDbProvider.delete(wallet.name);
    if (wallet.address ==
        await SharedPreferencesUtils.getCurrentWalletAddress()) {
      Wallet firstWallet =
          await WalletDbProvider.walletDbProvider.getFirstWallet();
      if (firstWallet != null) {
        await SharedPreferencesUtils.setCurrentWalletAddress(
            firstWallet.address);
      } else {
        await SharedPreferencesUtils.setCurrentWalletAddress(
            '');
      }
    }

    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: ScreenUtil.screenHeight - ScreenUtil().setWidth(278),
        height: 300,
        child: ListView.builder(
          itemBuilder: generateItem,
          itemCount: widget.wallets != null ? widget.wallets.length + 1 : 1,
          padding: EdgeInsets.only(top: 0),
        ));
  }
}

///去备份
class ToBackUpButton extends StatelessWidget {
  bool isShow = false;

  Function callback;

  ToBackUpButton(this.isShow, this.callback);

  @override
  Widget build(BuildContext context) {
    if (isShow) {
      return Container();
    } else {
      return FlatButton(
          color: Colors.transparent,
          onPressed: () {
            callback();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(40)),
              side: BorderSide(width: 1, color: Colors.white)),
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
          child: Text('去备份',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(22),
                color: Colors.white,
              )));
    }
  }
}
