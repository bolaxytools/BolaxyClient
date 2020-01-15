import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/address_db_provider.dart';
import 'package:wallet/db/model/address.dart';
import 'package:wallet/utils/scan_utils.dart';
import 'package:wallet/widgets/common_button.dart';
import 'package:wallet/widgets/notice_success_dialog.dart';

///新增地址
class NewAddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewAddressPageState();
  }
}

class NewAddressPageState extends State<NewAddressPage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  String name;
  String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            left: ScreenUtil().setWidth(20),
            top: ScreenUtil().setWidth(64),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: ScreenUtil().setWidth(50),
              color: Color(0xFFB5BFCB),
              onPressed: () {
                Application.router.pop(context);
              },
            ),
          ),
          Positioned(
            right: ScreenUtil().setWidth(40),
            top: ScreenUtil().setWidth(84),
            child: GestureDetector(
              child: Image.asset(
                'images/scan.png',
                width: ScreenUtil().setWidth(33),
              ),
              onTap: () {
                scan();
              },
            ),
          ),
          Positioned(
            left: ScreenUtil().setWidth(40),
            top: ScreenUtil().setWidth(150),
            child: Text(
              '新增地址',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48), color: Color(0xFF2F3B53)),
            ),
          ),
          Positioned(
              top: ScreenUtil().setWidth(288),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '地址别名',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
              )),
          Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(100),
            color: Color(0xFFF7F7FA),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(343)),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
                bottom: ScreenUtil().setWidth(4)),
            child: TextField(
              onChanged: (text) {
                name = text;
              },
              maxLength: 20,
              style: TextStyle(fontSize: ScreenUtil().setSp(24)),
              decoration: InputDecoration(
                hintText: '最多20个字符',
                border: InputBorder.none,
              ),
            ),
          ),
          Positioned(
              top: ScreenUtil().setWidth(467),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '地址',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(28), color: Color(0xFF2F3B53)),
              )),
          Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(84),
            color: Color(0xFFF7F7FA),
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(522)),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30)),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (text) {
                address = text;
              },
              style: TextStyle(fontSize: ScreenUtil().setSp(24)),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '地址',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(726),
                left: ScreenUtil().setWidth(40)),
//            width: ScreenUtil().setWidth(670),
//            height: ScreenUtil().setWidth(96),
            child: CommonButton(
              '确定添加',
              () {
                if (checkInput()) {
                  add(context);
                }
              },
              width: ScreenUtil().setWidth(670),
              height: ScreenUtil().setWidth(96),
              color: Color(0xFF616EE3),
            ),
          )
        ],
      ),
    );
  }

  Future<void> scan() async {
    focusNode.unfocus();
    String result = await ScanUtils.scan();
    print('scan result $result');
    controller.text = result;
    address = result;
  }

  bool checkInput() {
    if (name == null || name.isEmpty) {
      Fluttertoast.showToast(msg: '请输入别名', gravity: ToastGravity.CENTER);
      return false;
    } else if (address == null || address.isEmpty) {
      Fluttertoast.showToast(msg: '请输入地址', gravity: ToastGravity.CENTER);
      return false;
    } else if (!address.startsWith('0x')) {
      Fluttertoast.showToast(msg: '地址格式有误', gravity: ToastGravity.CENTER);
      return false;
    }
    return true;
  }

  Future add(BuildContext context) async {
    if (await AddressDbProvider.addressDbProvider
            .getAddressWithAddress(this.address) ==
        null) {
      Address address = Address(name, this.address);
      await AddressDbProvider.addressDbProvider.insert(address);

      NoticeDialog.showNoticeDialog(
          context, '新增成功', NoticeDialog.successImagePath, callback: () {
        Navigator.pop(context, true);
      });
    } else {
      Fluttertoast.showToast(msg: '该地址已经存在');
    }
  }
}
