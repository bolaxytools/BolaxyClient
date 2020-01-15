import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/address_db_provider.dart';
import 'package:wallet/db/model/address.dart';
import 'package:wallet/model/property.dart';
import 'package:wallet/widgets/choose_coin_dialog.dart';

///地址簿
class AddressBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddressBookState();
  }
}

class AddressBookState extends State<AddressBookPage> {
  List<Address> addresses;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/background_circle.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter)),
        child: Stack(
          children: <Widget>[
            Positioned(
                right: ScreenUtil().setWidth(40),
                top: ScreenUtil().setWidth(85),
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add_circle_outline,
                        size: ScreenUtil().setWidth(35),
                        color: Colors.white,
                      ),
                      Text(
                        '新增地址',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            color: Colors.white),
                      )
                    ],
                  ),
                  onTap: () {
                    Application.router
                        .navigateTo(context, '/new_address')
                        .then((refresh) {
                      if (refresh != null && refresh) {
                        getData();
                      }
                    });
                  },
                )),
            Positioned(
                top: ScreenUtil().setWidth(150),
                left: ScreenUtil().setWidth(40),
                child: Text(
                  '地址簿',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(48), color: Colors.white),
                )),
            Positioned(
                top: ScreenUtil().setWidth(174),
                left: ScreenUtil().setWidth(200),
                child: Text(
                  '${addresses != null ? addresses.length : 0}个联系人',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28), color: Colors.white),
                )),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(278)),
              child: ListView.builder(
                  itemCount: addresses != null ? addresses.length : 0,
                  itemBuilder: (context, index) {
                    return AddressItem(addresses[index]);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future getData() async {
    List<Address> addresses =
        await AddressDbProvider.addressDbProvider.getAddresses();
    setState(() {
      this.addresses = addresses;
    });
  }
}

class AddressItem extends StatelessWidget {
  Address address;

  AddressItem(this.address);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(194),
      alignment: Alignment.center,
      child: Container(
        width: ScreenUtil().setWidth(670),
        height: ScreenUtil().setWidth(174),
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFAEB3D0),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12)),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: ScreenUtil().setWidth(44),
                left: ScreenUtil().setWidth(30),
                width: ScreenUtil().setWidth(450),
                child: Text(
                  address.name,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(32),
                      color: Color(0xFF2F3B53)),
                  overflow: TextOverflow.ellipsis,
                )),
            Positioned(
                top: ScreenUtil().setWidth(100),
                left: ScreenUtil().setWidth(30),
                width: ScreenUtil().setWidth(450),
                child: Text(
                  address.address,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      color: Color(0xFF95A2B3)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            Positioned(
                top: ScreenUtil().setWidth(64),
                right: ScreenUtil().setWidth(30),
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setWidth(46),
                  decoration: new BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(237, 194, 136, 0.5),
                          blurRadius: 5)
                    ],
                    // 边色与边宽度
                    color: Color.fromRGBO(237, 194, 136, 0.89),
                    // 底色
                    borderRadius: new BorderRadius.circular(
                        ScreenUtil().setWidth(40)), // 圆角度
                  ),
                  child: GestureDetector(
                    child: Text(
                      '转账',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          color: Colors.white),
                    ),
                    onTap: () {
                      transferAccounts(context);
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }

  ///转账
  void transferAccounts(BuildContext context) {
//    Application.router
//        .navigateTo(context, '/transfer?address=${address.address}');
    ChooseCoinDialog.showChooseCoinDialog(context,address.address);
  }
}
