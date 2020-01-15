import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/model/token_info.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/utils/string_utils.dart';
import 'package:wallet/widgets/character_visible.dart';
import 'package:wallet/widgets/load_more.dart';

import '../Application.dart';

///子币转账
class CoinDetailPage extends StatefulWidget {
  ///货币名称
  String name;

  ///金额
  String balance;

  ///子币合约地址
  String contract;

  CoinDetailPage(this.name, this.balance, this.contract);

  @override
  State<StatefulWidget> createState() {
    return CoinDetailPageState();
  }
}

class CoinDetailPageState extends State<CoinDetailPage> {
  int currentPage = 1;
  bool isLoading = false;

  TokenInfo tokenInfo;

  ///地址
  String address;

  bool propertyVisible = true;

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (tokenInfo != null &&
            tokenInfo.txList != null &&
            tokenInfo.txList.total > tokenInfo.txList.txs.length) {
          currentPage++;
          getData();
        }
      }
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
              color: Color(0xFFB5BFCB),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(40)),
            child: Text(
              '${widget.name != null ? widget.name : ''}转账',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48), color: Color(0xFF2F3B53)),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(300),
            margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(70),
                left: ScreenUtil().setWidth(40)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/card_transfer_accounts.png'),
                    fit: BoxFit.cover)),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    top: ScreenUtil().setWidth(48),
                    right: ScreenUtil().setWidth(350),
                    child: Text(
                      (tokenInfo != null &&  tokenInfo.coin != null) ? tokenInfo.coin.symbol : '',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          color: Color(0xFFF8F8F8)),
                    )),
                Positioned(
                    right: ScreenUtil().setWidth(260),
                    top: ScreenUtil().setWidth(20),
                    width: ScreenUtil().setWidth(70),
                    child: CharacterVisible(propertyVisible, Color(0xFFF8F8F8),
                        (visible) {
                      setState(() {
                        propertyVisible = visible;
                      });
                    })),
                Positioned(
                    top: ScreenUtil().setWidth(100),
                    child: Text(
                      propertyVisible
                          ? ((tokenInfo != null && tokenInfo.coin != null)
                              ? StringUtils.getProperty(tokenInfo.coin.balance)
                              : '')
                          : '****',
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(60),
                          color: Color(0xFFF8F8F8)),
                    )),
                Positioned(
                    width: ScreenUtil().setWidth(335),
                    height: ScreenUtil().setWidth(90),
                    left: 0,
                    bottom: 0,
                    child: FlatButton(
                        onPressed: () {
                          if (tokenInfo != null) {
                            print('contract ${tokenInfo.coin.contract}');
                            Application.router.navigateTo(
                                context,
                                '/transfer?symbol=${tokenInfo.coin.desc}&balance=${tokenInfo.coin.balance}&bap=${tokenInfo.coin.bap}'
                                '&contract=${tokenInfo.coin.contract}&decimals=${Uri.encodeComponent(tokenInfo.coin.decimals.toString())}');
                          }
                        },
                        child: Text(
                          '转账',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.white),
                        ))),
                Positioned(
                    bottom: ScreenUtil().setWidth(20),
                    width: ScreenUtil().setWidth(1),
                    height: ScreenUtil().setWidth(50),
                    child: Container(
                      color: Colors.white,
                    )),
                Positioned(
                    width: ScreenUtil().setWidth(335),
                    height: ScreenUtil().setWidth(90),
                    right: 0,
                    bottom: 0,
                    child: FlatButton(
                        onPressed: () {
                          Application.router.navigateTo(context, '/gathering');
                        },
                        child: Text(
                          '收款',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.white),
                        ))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(50),
                left: ScreenUtil().setWidth(40)),
            child: Text(
              '交易记录',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(36),
                  color: Color(0xFF2F3B53),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(40)),
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setHeight(550),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount:
              tokenInfo != null ? tokenInfo.txList.txs.length + 1 : 0,
              controller: scrollController,
              itemBuilder: (BuildContext context, int position) {
                return TransferItemView(
                    tokenInfo.txList.txs,
                    position,
                    address,
                    tokenInfo.coin != null ? tokenInfo.coin.symbol : '',
                    tokenInfo.txList.total > tokenInfo.txList.txs.length);
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> getData() async {
    if (!isLoading) {
      isLoading = true;
      address = await SharedPreferencesUtils.getCurrentWalletAddress();
      TokenInfo tokenInfo = await NetUtils.getTokenInfo(
          address, widget.contract, currentPage, 10);
      setState(() {
        print('tokenInfo ${tokenInfo.toJson()}');
        print('tokenInfo ${this.tokenInfo}');
        if (this.tokenInfo == null) {
          this.tokenInfo = tokenInfo;
        } else {
          this.tokenInfo.txList.txs.addAll(tokenInfo.txList.txs);
        }
      });
      isLoading = false;
    }
  }

  Future<void> getMoreData() async {
    currentPage++;
    TokenInfo tokenInfo =
        await NetUtils.getTokenInfo(address, widget.contract, currentPage, 10);
    setState(() {
      this.tokenInfo.txList.txs.addAll(tokenInfo.txList.txs);
    });
  }
}

class TransferItemView extends StatelessWidget {
  List<TxsBean> list;
  int position;
  String myAddress;
  String symbol;

  bool isHaveMore; //是否还有更多

  TransferItemView(
      this.list, this.position, this.myAddress, this.symbol, this.isHaveMore);

  @override
  Widget build(BuildContext context) {
    if (position == list.length) {
      return LoadMore(isHaveMore);
    } else {
      return Container(
        width: ScreenUtil().setWidth(670),
        height: ScreenUtil().setWidth(136),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: ScreenUtil().setWidth(56),
              child: Image.asset(
                isRollOut(list[position].addrFrom)
                    ? 'images/roll_out.png'
                    : 'images/shift_to.png',
                width: ScreenUtil().setWidth(24),
                height: ScreenUtil().setWidth(24),
              ),
            ),
            Positioned(
                top: ScreenUtil().setWidth(30),
                left: ScreenUtil().setWidth(57),
                width: ScreenUtil().setWidth(200),
                child: Text(
                  isRollOut(list[position].addrFrom)
                      ? list[position].addrTo
                      : list[position].addrFrom,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: Color(0xFF2F3B53)),
                  overflow: TextOverflow.ellipsis,
                )),
            Positioned(
                left: ScreenUtil().setWidth(57),
                top: ScreenUtil().setWidth(73),
                child: Text(
                  DateUtil.formatDateMs(list[position].txTime),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      color: Color(0xFFB5BFCB)),
                )),
            Positioned(
                top: ScreenUtil().setWidth(30),
                width: ScreenUtil().setWidth(200),
                right: 0,
                child: Text(
                  '${isRollOut(list[position].addrFrom) ? '-' : '+'}${StringUtils.getProperty(list[position].amount)} $symbol',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xFF31BD88)),
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
      );
    }
  }

  ///是否是转出
  bool isRollOut(String fromAddress) {
    return myAddress == fromAddress;
  }
}
