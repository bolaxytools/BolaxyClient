import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/model/transaction_history.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/shared_preferences_utils.dart';
import 'package:wallet/utils/string_utils.dart';
import 'package:wallet/widgets/load_more.dart';

///转账详情
class TransferDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TransferDetailState();
  }
}

class TransferDetailState extends State<TransferDetailPage> {
  ///当前账号的地址
  String address;

  TransactionHistory transactionHistory;

  ScrollController scrollController;
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (transactionHistory != null &&
            transactionHistory.total > transactionHistory.txs.length) {
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
                Application.router.pop(context);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(40)),
            child: Text(
              '转账明细',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48), color: Color(0xFF2F3B53)),
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(40),
                bottom: ScreenUtil().setWidth(80)),
            width: ScreenUtil().setWidth(670),
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: transactionHistory != null
                  ? transactionHistory.txs.length + 1
                  : 0,
              controller: scrollController,
              itemBuilder: (BuildContext context, int position) {
                return TransferItemView(
                    transactionHistory.txs,
                    position,
                    address,
                    transactionHistory.total > transactionHistory.txs.length);
              },
            ),
          ))
        ],
      ),
    );
  }

  Future getData() async {
    if (!isLoading) {
      isLoading = true;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      address =
          sharedPreferences.getString(SharedPreferencesUtils.sp_current_wallet);
      TransactionHistory data =
          await NetUtils.getHistory(address, currentPage, 10);
      setState(() {
        if (transactionHistory == null) {
          transactionHistory = data;
        } else {
          transactionHistory.txs.addAll(data.txs);
        }
      });
      isLoading = false;
    }
  }
}

class TransferItemView extends StatelessWidget {
  List<TxsBean> list;
  int position;
  bool isHaveMore; //是否还有更多

  ///当前账号的地址
  String address;

  TransferItemView(this.list, this.position, this.address, this.isHaveMore);

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
                getIcon(list[position].addrFrom),
                width: ScreenUtil().setWidth(24),
                height: ScreenUtil().setWidth(24),
              ),
            ),
            Positioned(
                top: ScreenUtil().setWidth(30),
                left: ScreenUtil().setWidth(57),
                width: ScreenUtil().setWidth(300),
                child: Text(
                  isShiftTo(list[position].addrFrom)
                      ? list[position].addrFrom
                      : list[position].addrTo,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(26),
                      color: Color(0xFF2F3B53)),
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
                right: 0,
                child: Text(
                  '${isShiftTo(list[position].addrFrom) ? '+' : '-'}${StringUtils.getProperty(list[position].amount)} ${list[position].symbol}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: isShiftTo(list[position].addrFrom)
                          ? Color(0xFF31BD88)
                          : Color(0xFFF2453C)),
                ))
          ],
        ),
      );
    }
  }

  ///获取转入或转出的图片
  String getIcon(String addressFrom) {
    if (isShiftTo(addressFrom)) {
      return 'images/shift_to.png';
    } else {
      return 'images/roll_out.png';
    }
  }

  ///是否是转入
  bool isShiftTo(String addressFrom) {
    return address != addressFrom;
  }
}
