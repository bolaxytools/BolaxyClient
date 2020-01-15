import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/circle_db_provider.dart';
import 'package:wallet/db/model/circle_db.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/model/CoinBean.dart';
import 'package:wallet/model/circle.dart';
import 'package:wallet/model/property.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/utils/string_utils.dart';
import 'package:wallet/widgets/character_visible.dart';
import 'package:wallet/widgets/common_button.dart';
import 'package:wallet/widgets/switch_wallet_dialog.dart';

///主页
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Property property;
  Wallet wallet;
  CircleDb circleDb;

  bool balanceVisible = true;

  ///财产金额是否可见

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF616EE3),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: ScreenUtil().setWidth(60),
              left: ScreenUtil().setWidth(20),
              child: IconButton(
                icon: Icon(
                  Icons.menu,
                  size: ScreenUtil().setWidth(40),
                  color: Colors.white,
                ),
                onPressed: () {
                  switchWallet(context);
                },
              )),
          Positioned(
              right: ScreenUtil().setWidth(20),
              top: ScreenUtil().setWidth(60),
              child: FlatButton(
                  onPressed: () {},
                  child: Text(
                    circleDb != null ? circleDb.name : '',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28), color: Colors.white),
                  ))),
          Positioned(
              top: ScreenUtil().setWidth(165),
              left: ScreenUtil().setWidth(307),
              child: Text(
                property != null ? property.mainCoin.symbol : '',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(24), color: Color(0x80FFFFFF)),
              )),
          Positioned(
              top: ScreenUtil().setWidth(138),
              left: ScreenUtil().setWidth(400),
              width: ScreenUtil().setWidth(70),
              child: CharacterVisible(balanceVisible, Colors.white,
                  (bool visible) {
                setState(() {
                  balanceVisible = visible;
                });
              })),
          Positioned(
              top: ScreenUtil().setWidth(154),
              right: 0,
              child: Container(
                width: ScreenUtil().setWidth(134),
                height: ScreenUtil().setWidth(52),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                  // 底色
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                      bottomLeft: Radius.circular(ScreenUtil().setWidth(30))),
                ),
                child: FlatButton(
                  onPressed: () {
                    Application.router.navigateTo(context, '/transferDetail');
                  },
                  child: Text(
                    '转账明细',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24), color: Colors.white),
                  ),
                  padding: EdgeInsets.only(top: 0),
                ),
              )),
          Positioned(
              top: ScreenUtil().setWidth(213),
              child: Text(
                balanceVisible
                    ? StringUtils.getProperty(
                        property == null ? '0' : property.mainCoin.balance,
                        point: 2)
                    : '***',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(76), color: Colors.white),
              )),
          Positioned(
              top: ScreenUtil().setWidth(348),
              left: ScreenUtil().setWidth(90),
              child: Container(
                width: ScreenUtil().setWidth(250),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(40)))),
                child: FlatButton(
                    onPressed: () {
                      Application.router.navigateTo(context, '/gathering');
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(46)),
                          child: Image.asset(
                            'images/gathering_homepage.png',
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setWidth(30),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Text(
//                            AppLocalizations.$t('gathering'),
                            '收款',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(26),
                                color: Color(0xFF6470E4)),
                          ),
                        )
                      ],
                    )),
              )),
          Positioned(
              top: ScreenUtil().setWidth(348),
              right: ScreenUtil().setWidth(90),
              child: Container(
                width: ScreenUtil().setWidth(250),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(40)))),
                child: FlatButton(
                    onPressed: () {
                      if (property != null) {
                        Application.router
                            .navigateTo(
                                context,
                                '/transfer?symbol=${property.mainCoin.symbol}'
                                '&balance=${property.mainCoin.balance}'
                                '&bap=${property.mainCoin.bap}')
                            .then((isRefresh) {
                          if (isRefresh != null && isRefresh) {
                            getData();
                          }
                        });
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(46)),
                          child: Image.asset(
                            'images/transfer_accounts_homepage.png',
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setWidth(30),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                          child: Text(
                            '转账',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(26),
                                color: Color(0xFF6470E4)),
                          ),
                        )
                      ],
                    )),
              )),
          Positioned(
              top: ScreenUtil().setWidth(467),
              child: Container(
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setHeight(830),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                      topRight: Radius.circular(ScreenUtil().setWidth(40)),
                    )),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: ScreenUtil().setWidth(40),
                        top: ScreenUtil().setWidth(35),
                        child: Text(
                          '币种资产',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(36),
                              color: Color(0xFF2F3B53),
                              fontWeight: FontWeight.w600),
                        )),
                    AddTokenButton(
                        property != null && property.extCoinList.length != 0,
                        () {
                      getData();
                    }),
                    Positioned(
                        top: ScreenUtil().setWidth(115),
                        width: ScreenUtil().setWidth(750),
                        height: ScreenUtil().setHeight(730),
                        child: CurrencyList(
                            property != null ? property.extCoinList : null, () {
                          getData();
                        }))
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();

  }

  void switchWallet(BuildContext context) {
    SwitchWalletDialog.showSwitchWalletDialog(context,
        (selectWalletAddress) async {
      SwitchWalletDialog.hideSwitchWalletDialog(context);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
          SharedPreferencesUtils.sp_current_wallet, selectWalletAddress);
      getData();
    });
  }

  Future getData() async {
    ///获取当前的钱包名称
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentWalletAdress =
        preferences.getString(SharedPreferencesUtils.sp_current_wallet);

    print('getData currentWalletAdress $currentWalletAdress');

    if (currentWalletAdress == null || currentWalletAdress.isEmpty) {
      wallet = await WalletDbProvider.walletDbProvider.getFirstWallet();
      print('getData currentWalletAdress $wallet');
      print('getData currentWalletAdress ${wallet.address}');

      await preferences.setString(
          SharedPreferencesUtils.sp_current_wallet, wallet.address);
    } else {
      wallet = await WalletDbProvider.walletDbProvider
          .getWalletWithAddress(currentWalletAdress);
    }

    print('getData currentWalletAdress keyStore  ${wallet.keyStore}');

    getCircle();

    Property property = await NetUtils.getProperty(wallet.address);

    setState(() {
      this.property = property;
    });
  }

  ///获取圈子数据
  Future getCircle() async {
    if (wallet.circleChainId == null || wallet.circleChainId.isEmpty) {
      Circle circle = await NetUtils.getDefaultLeague(wallet.address);
      this.circleDb = CircleDb(circle, wallet.address);
      this.circleDb.isDefault = true;
      await CircleDbProvider.circleDbProvider.insert(circleDb);
      wallet.circleChainId = circle.chainId;
      print('getCircle wallet.circleChainId ${wallet.circleChainId}');
      print('getCircle wallet.address ${wallet.address}');
      await WalletDbProvider.walletDbProvider.update(wallet);
    } else {
      this.circleDb = await CircleDbProvider.circleDbProvider
          .getCircle(wallet.circleChainId, wallet.address);
    }

    setState(() {
      this.circleDb = circleDb;
    });
  }
}

class CurrencyList extends StatelessWidget {
  List<CoinBean> coinList;

  Function refreshCallback;

  CurrencyList(this.coinList, this.refreshCallback);

  @override
  Widget build(BuildContext context) {
    if (coinList != null && coinList.length != 0) {
      return ListView.builder(
          itemBuilder: _itemBuilder,
          itemCount: coinList != null ? coinList.length : 0,
          padding: EdgeInsets.only(top: 0));
    } else {
      return AddToken(refreshCallback);
    }
  }

  Widget _itemBuilder(BuildContext context, int position) {
    return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setWidth(194),
        alignment: Alignment.center,
        child: GestureDetector(
          child: Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(174),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(174, 179, 208, 0.2),
                      blurRadius: ScreenUtil().setWidth(20)),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(12)))),
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: ScreenUtil().setWidth(40),
                    child: Container(
                      width: ScreenUtil().setWidth(6),
                      height: ScreenUtil().setWidth(50),
                      color: Color(0xFF3BD07F),
                    )),
                Positioned(
                  top: ScreenUtil().setWidth(47),
                  left: ScreenUtil().setWidth(56),
                  child: Image.network(coinList[position].logo,
                      width: ScreenUtil().setWidth(36),
                      height: ScreenUtil().setWidth(36)),
                ),
                Positioned(
                    top: ScreenUtil().setWidth(44),
                    left: ScreenUtil().setWidth(112),
                    child: Text(
                      coinList[position].desc,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xFF2F3B53)),
                    )),
                Positioned(
                    right: ScreenUtil().setWidth(40),
                    top: ScreenUtil().setWidth(44),
                    child: Text(
                      StringUtils.getProperty(coinList[position].balance,
                          point: 2),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Color(0xFF2F3B53)),
                    )),
//            Positioned(
//                top: ScreenUtil().setWidth(93),
//                right: ScreenUtil().setWidth(40),
//                child: Text(
//                  '≈￥0.00',
//                  style: TextStyle(
//                      fontSize: ScreenUtil().setSp(26),
//                      color: Color(0xFF95A2B3)),
//                ))
              ],
            ),
          ),
          onTap: () {
            Application.router.navigateTo(
                context,
                '/coinDetail?name=${coinList[position].desc}'
                '&balance=${coinList[position].balance}'
                '&contract=${coinList[position].contract}');
          },
        ));
  }

  ///查找对应的icon图片
  String getCoinIcon(symbol) {
    switch (symbol) {
      case 'Brc1':
        return 'images/ETH.png';
    }
    return 'images/ETH.png';
  }
}

class AddToken extends StatelessWidget {
  Function callback;

  AddToken(this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
            child: Image.asset(
              'images/no_imformation.png',
              width: ScreenUtil().setWidth(110),
              height: ScreenUtil().setWidth(122),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
              child: Text(
                '暂无数据',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(26), color: Color(0xFFCED7DC)),
              )),
          Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
              child: CommonButton(
                '添加token',
                () {
                  Application.router
                      .navigateTo(context, '/addToken')
                      .then((isRefresh) {
                    if (isRefresh != null && isRefresh) {
                      callback();
                    }
                  });
                },
                width: ScreenUtil().setWidth(300),
                height: ScreenUtil().setWidth(80),
                color: Color(0xFFEDC288),
              ))
        ],
      ),
    );
  }
}

class AddTokenButton extends StatelessWidget {
  bool isShow;

  Function callback;

  AddTokenButton(this.isShow, this.callback);

  @override
  Widget build(BuildContext context) {
    return isShow
        ? Positioned(
            right: ScreenUtil().setWidth(40),
            top: ScreenUtil().setWidth(20),
            child: FlatButton(
                onPressed: () {
                  Application.router
                      .navigateTo(context, '/addToken')
                      .then((isRefresh) {
                    if (isRefresh != null && isRefresh) {
                      callback();
                    }
                  });
                },
                child: Text(
                  '+ 添加token',
                  style: TextStyle(
                      color: Color(0xFF616EE3),
                      fontSize: ScreenUtil().setSp(26)),
                )))
        : Container();
  }
}
