import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/model/token_search_result.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/widgets/common_button.dart';

class AddToken extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddTokenState();
  }
}

class AddTokenState extends State<AddToken> {
  TokenSearchResult tokenSearchResult;

  String inputText;

  ///数据是否改变，改变时返回主页要刷新
  bool isChange = false;

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: ScreenUtil().setWidth(40),
            top: ScreenUtil().setWidth(80),
            child: Container(
              width: ScreenUtil().setWidth(580),
              height: ScreenUtil().setWidth(80),
              color: Color(0xFFF7F7FA),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      left: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(20),
                      child: Icon(
                        Icons.search,
                        size: ScreenUtil().setWidth(40),
                        color: Color(0xFFB5BFCB),
                      )),
                  Positioned(
                    width: ScreenUtil().setWidth(500),
                    left: ScreenUtil().setWidth(60),
//                    height: ScreenUtil().setWidth(40),
                    child: TextField(
                      controller: textEditingController,
                      style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: '请输入合约地址或简称',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only()),
                      onChanged: (text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                      onEditingComplete: () {
                        search(inputText);
                      },
                    ),
                  ),
                  Positioned(
//                      top: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(10),
                      width: ScreenUtil().setWidth(60),
                      child: FlatButton(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10),
                              right: ScreenUtil().setWidth(10)),
                          onPressed: () {
                            textEditingController.text = '';
                            inputText = '';
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Color(0xFFB5BFCB),
                            size: ScreenUtil().setWidth(40),
                          )))
                ],
              ),
            ),
          ),
          Positioned(
              top: ScreenUtil().setWidth(80),
              left: ScreenUtil().setWidth(630),
              width: ScreenUtil().setWidth(100),
              child: FlatButton(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(0),
                      right: ScreenUtil().setWidth(0)),
                  onPressed: () {
                    Navigator.pop(context, isChange);
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xFF2F3B53)),
                  ))),
          Positioned(
              top: ScreenUtil().setWidth(180),
              child: Container(
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setHeight(1180),
                child: SearchResult(tokenSearchResult, () {
                  search(inputText);
                  isChange = true;
                }),
              ))
        ],
      ),
    );
  }

  Future<void> search(String word) async {
    if (word != null && word.isNotEmpty) {
      String address = await SharedPreferencesUtils.getCurrentWalletAddress();
      TokenSearchResult tokenSearchResult =
          await NetUtils.searchToken(address, word);
      setState(() {
        this.tokenSearchResult = tokenSearchResult;
      });
    } else {
      Fluttertoast.showToast(msg: '请输入搜索内容');
    }
  }
}

class SearchResult extends StatelessWidget {
  TokenSearchResult tokenSearchResult;

  Function callback;

  SearchResult(this.tokenSearchResult, this.callback);

  @override
  Widget build(BuildContext context) {
    if (tokenSearchResult != null && tokenSearchResult.tokenList.length > 0) {
      return ListView.builder(
          itemBuilder: _itemBuilder,
          itemCount: tokenSearchResult.tokenList.length,
          padding: EdgeInsets.only(top: 0));
    } else {
      return Container(
        width: ScreenUtil().setWidth(750),
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(280)),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(),
                child: Image.asset(
                  'images/no_imformation.png',
                  width: ScreenUtil().setWidth(110),
                  height: ScreenUtil().setWidth(122),
                )),
            Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
                child: Text(
                  '查无结果',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: Color(0xFFCED7DC)),
                )),
          ],
        ),
      );
    }
  }

  Widget _itemBuilder(BuildContext context, int position) {
    return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setWidth(142),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: ScreenUtil().setWidth(40),
                left: ScreenUtil().setWidth(40),
                child: Image.network(
                  'https://cdn.mytoken.org/FhnhgIwiDRHeoSDa0_ZEJ1b1ZtPR',
                  width: ScreenUtil().setWidth(64),
                  height: ScreenUtil().setWidth(64),
                )),
            Positioned(
                left: ScreenUtil().setWidth(124),
                top: ScreenUtil().setWidth(20),
                child: Text(
                  tokenSearchResult.tokenList[position].desc,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color: Color(0xFF2F3B53),
                      fontWeight: FontWeight.w600),
                )),
            Positioned(
                left: ScreenUtil().setWidth(124),
                top: ScreenUtil().setWidth(70),
                child: Text(
                  tokenSearchResult.tokenList[position].symbol,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(24),
                      color: Color(0xFF95A2B3)),
                )),
            Positioned(
                top: ScreenUtil().setWidth(46),
                right: ScreenUtil().setWidth(40),
                child: CommonButton(
                  '添加',
                  () {
                    add(tokenSearchResult.tokenList[position]);
                  },
                  width: ScreenUtil().setWidth(110),
                  height: ScreenUtil().setWidth(50),
                  color: Color(0xFFEDC288),
                  textSize: 24,
                  enable: !tokenSearchResult.tokenList[position].followed,
                  textDisabled: '已添加',
                ))
          ],
        ));
  }

  Future<void> add(TokenListBean tokenListBean) async {
    String address = await SharedPreferencesUtils.getCurrentWalletAddress();
    await NetUtils.followToken(address, tokenListBean.contract);
    callback();
  }
}
