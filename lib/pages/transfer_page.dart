import 'dart:convert';
import 'dart:math' as prefix0;

import 'package:convert_hex/convert_hex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/model/wallet.dart';
import 'package:wallet/db/wallet_db_provider.dart';
import 'package:wallet/utils/native_communication.dart';
import 'package:wallet/utils/net_utils.dart';
import 'package:wallet/utils/scan_utils.dart';
import 'package:wallet/utils/string_utils.dart';
import 'package:wallet/widgets/common_button.dart';
import 'package:wallet/widgets/loading_dialog.dart';
import 'package:wallet/widgets/notice_success_dialog.dart';
import 'package:wallet/widgets/verify_password_dialog.dart';

///转账页面
class TransferPage extends StatefulWidget {
  static const double MIN_GAS = 0.00003;
  static const int TEMP_UNIT = 100000000;

  ///币种
  String symbol;

  ///金额
  String balance; //0.00003 0.002  busd

  ///转账金额
  num transferMoney;

  //gas值
  String bap;

  String serviceCharge; //手续费   BUSD 10的18次方

  ///传入的地址
  String address;

  ///智能合约地址
  String contract;

  ///brc20 单位
  String decimals;

  TransferPage(this.symbol, this.balance, this.address,this.bap,
      {this.contract, this.decimals});

  double sliderValue = 0.00003;

  @override
  State<StatefulWidget> createState() {
    return TransferPageState();
  }
}

class TransferPageState extends State<TransferPage> {
  final TextEditingController addressController = TextEditingController();

  FocusNode focusNode = FocusNode();

  bool isNeedRefresh = false; //返回主页时，是否需要刷新数据

  @override
  void initState() {
    super.initState();
    addressController.text = widget.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setWidth(1300),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(64),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: ScreenUtil().setWidth(50),
                      color: Color(0xFFB5BFCB),
                      onPressed: () {
                        Navigator.pop(context, isNeedRefresh);
                      },
                    ),
                  ),
                  Positioned(
                      right: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(84),
                      width: ScreenUtil().setWidth(80),
                      child: FlatButton(
                          padding: EdgeInsets.only(left: 0, right: 0),
                          onPressed: () {
                            toScan();
                          },
                          child: Image.asset(
                            'images/scan.png',
                            width: ScreenUtil().setWidth(33),
                          ))

//                    GestureDetector(
//                      child: Image.asset(
//                        'images/scan.png',
//                        width: ScreenUtil().setWidth(33),
//                      ),
//                      onTap: () {
////                        scan();
//                        toScan();
//                      },
//                    ),
                      ),
                  Positioned(
                      top: ScreenUtil().setWidth(150),
                      left: ScreenUtil().setWidth(40),
                      child: Text(
                        '${widget.symbol}转账',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(288),
                      left: ScreenUtil().setWidth(40),
                      child: Text(
                        '收款地址',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(290),
                      right: ScreenUtil().setWidth(40),
                      child: GestureDetector(
                        child: Image.asset(
                          'images/address_list.png',
                          width: ScreenUtil().setWidth(32),
                          height: ScreenUtil().setWidth(35),
                        ),
                        onTap: () {
                          selectAddress(context);
                        },
                      )),
                  Positioned(
                      left: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(343),
                      child: Container(
                        width: ScreenUtil().setWidth(670),
                        height: ScreenUtil().setWidth(84),
                        color: Color(0xFFF7F7FA),
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30)),
                        child: TextField(
                          controller: addressController,
                          focusNode: focusNode,
                          onChanged: (text) {},
                          style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                          decoration: InputDecoration(
                            hintText: '请输入收款地址',
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(467),
                      left: ScreenUtil().setWidth(40),
                      child: Text(
                        '转账数量',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(471),
                      right: ScreenUtil().setWidth(40),
                      child: Text(
                        '余额 ${StringUtils.getProperty(widget.balance)}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      left: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(522),
                      child: Container(
                        width: ScreenUtil().setWidth(670),
                        height: ScreenUtil().setWidth(84),
                        color: Color(0xFFF7F7FA),
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30)),
                        child: TextField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onChanged: (text) {
                            setState(() {
                              print(
                                  'number widget.transferMoney ${widget.transferMoney}');
                              widget.transferMoney = num.parse(text);
                            });
                          },
                          style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                          decoration: InputDecoration(
                            hintText: '请输入转账数量',
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(646),
                      left: ScreenUtil().setWidth(40),
                      child: Text(
                        '备注信息',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      left: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(700),
                      child: Container(
                        width: ScreenUtil().setWidth(670),
                        height: ScreenUtil().setWidth(140),
                        color: Color(0xFFF7F7FA),
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30)),
                        child: TextField(
                          onChanged: (text) {},
                          style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: '选填',
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(880),
                      left: ScreenUtil().setWidth(40),
                      child: Text(
                        '手续费',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(885),
                      right: ScreenUtil().setWidth(40),
                      child: Text(
                        widget.sliderValue.toString(),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(24),
                            color: Color(0xFF2F3B53)),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(1000),
                      right: ScreenUtil().setWidth(40),
                      child: Text(
                        '${TransferPage.MIN_GAS} ${widget.symbol}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Color(0xFF8FA1AF)),
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(920),
                      width: ScreenUtil().setWidth(650),
                      left: ScreenUtil().setWidth(50),
                      child: Slider(
                        value: widget.sliderValue,
                        max: 0.002,
                        min: TransferPage.MIN_GAS,
                        activeColor: Colors.blue,
                        onChanged: (double val) {
                          this.setState(() {
                            widget.sliderValue =
                                double.parse(val.toStringAsPrecision(4));
                          });
                        },
                      )),
                  Positioned(
                      top: ScreenUtil().setWidth(1200),
                      left: ScreenUtil().setWidth(40),
                      child: CommonButton(
                        '确定转账',
                        () {
                          if (checkInput()) {
                            toTransfer();
                          }
                        },
                        color: Color(0xFF616EE3),
                        width: ScreenUtil().setWidth(670),
                        height: ScreenUtil().setWidth(96),
                      ))
                ],
              ),
            )
          ],
        )));
  }

  Future<void> toScan() async {
    focusNode.unfocus();
    manageResult(await ScanUtils.scan());
  }

  bool checkInput() {
    print('checkInput widget.addressController ${addressController.text}');

    num balance = BigInt.from(num.parse(widget.balance)) /
        BigInt.from(prefix0.pow(10, 18));
    if (addressController.text.isEmpty) {
      Fluttertoast.showToast(msg: '请输入收款地址');
      return false;
    } else if (widget.transferMoney == null || widget.transferMoney == 0) {
      Fluttertoast.showToast(msg: '请输入转账数量');
      return false;
    } else if (widget.transferMoney + widget.sliderValue > balance) {
      Fluttertoast.showToast(msg: '余额不足');
      return false;
    } else {
      return true;
    }
  }

  Future toTransfer() async {
    LoadingDialog.showLoading(context);
    Wallet wallet = await WalletDbProvider.walletDbProvider.getCurrentWallet();

    String gas = Hex.encode((widget.sliderValue * prefix0.pow(10, 18)).toInt());

    String nonce = await NetUtils.getNonce(wallet.address);
    List<dynamic> array = jsonDecode(wallet.privateKey);

    String transaction;

    print('widget.contract ${widget.contract}');
    print('widget.transferMoney ${widget.transferMoney}');
    print('addressController.text ${addressController.text}');
    print('widget.sliderValue ${widget.sliderValue}');
    if (widget.contract != null && widget.contract.isNotEmpty) {
      print('widget.decimals ${widget.decimals}');
      String value = '0x' +
          ((BigInt.from(widget.transferMoney * TransferPage.TEMP_UNIT) *
                  BigInt.from(prefix0.pow(10, int.parse(widget.decimals)) /
                      TransferPage.TEMP_UNIT)))
              .toRadixString(16);

      ///erc20转账
      transaction = await NativeCommunication.signERC20Tx(
          array[2],
          wallet.password,
          wallet.address,
          '0x' + gas,
          widget.contract,
          '0x0',
          nonce,
          widget.bap,
          addressController.text,
          value);
    } else {
      String value = '0x' +
          ((BigInt.from(widget.transferMoney * TransferPage.TEMP_UNIT) *
                  BigInt.from(prefix0.pow(10, 18) / TransferPage.TEMP_UNIT)))
              .toRadixString(16);

      ///主币转账
      transaction = await NativeCommunication.generateTransaction(
          array[2],
          wallet.password,
          wallet.address,
          '0x' + gas,
          addressController.text,
          value,
          nonce,
          widget.bap);
    }

    LoadingDialog.hideLoading(context);

    VerifyPasswordDialog.showInputPasswordDialog(context, wallet.password,
        () async {
      bool isSuccess = await NetUtils.deal(wallet.address, transaction);
      if (isSuccess) {
        isNeedRefresh = true;
        NoticeDialog.showNoticeDialog(
            context, '提交成功', NoticeDialog.successImagePath, callback: () {
//          Navigator.pop(context, true);
        });
      } else {
        Fluttertoast.showToast(msg: '提交失败');
      }
    });
  }

  Future transfer() async {
//    VerifyPasswordDialog.showInputPasswordDialog(context, wallet.password, () {
//      NoticeDialog.showNoticeDialog(
//          context, '转账成功', NoticeDialog.successImagePath);
//    });
  }

  void selectAddress(BuildContext context) {
    Application.router.navigateTo(context, '/selectPayee').then((value) {
      setState(() {
        addressController.text = value;
        print(
            'selectAddress widget.addressController.text ${addressController.text}');
      });
    });
  }

  void manageResult(String barcode) {
    addressController.text = barcode;
  }
}
