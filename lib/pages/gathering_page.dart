import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/widgets/common_button.dart';

///收款页
class GatheringPage extends StatefulWidget {
  String walletName;

  @override
  State<StatefulWidget> createState() {
    return GatheringPageState();
  }
}

class GatheringPageState extends State<GatheringPage> {
  Wallet wallet;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF616EE3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setWidth(64)),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: ScreenUtil().setWidth(50),
              color: Color(0xFFFFFFFF),
              onPressed: () {
                Application.router.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(40)),
            child: Text(
              '收款码',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48), color: Colors.white),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(860),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(70)),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/card_gathering.png'),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
                  child: QrImage(
                    data: wallet != null ? wallet.address : '',
                    size: ScreenUtil().setWidth(390),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(25)),
                  child: Text(
                    '收款地址',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xFF95A2B3)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(8),
                      left: ScreenUtil().setWidth(54),
                      right: ScreenUtil().setWidth(54)),
                  child: Text(
                    wallet != null ? wallet.address : '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28),
                        color: Color(0xFF2F3B53)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(126)),
                  child: CommonButton(
                    '复制收款地址',
                    () {
                      Clipboard.setData(ClipboardData(
                          text: wallet != null ? wallet.address : ''));
                      Fluttertoast.showToast(msg: '已复制');
                    },
                    width: ScreenUtil().setWidth(350),
                    height: ScreenUtil().setWidth(96),
                    color: Color(0xFFEDC288),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String currentWalletName =
        preferences.getString(SharedPreferencesUtils.sp_current_wallet);
    Wallet wallet = await WalletDbProvider.walletDbProvider
        .getWalletWithAddress(currentWalletName);
    setState(() {
      this.wallet = wallet;
    });
  }
}
