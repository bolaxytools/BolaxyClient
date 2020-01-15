import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallet/Application.dart';
import 'package:wallet/db/address_db_provider.dart';
import 'package:wallet/db/model/address.dart';

///选择收款人
class SelectPayeePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectPayeeState();
  }
}

class SelectPayeeState extends State<SelectPayeePage> {
  List<Address> addresses;

  @override
  void initState() {
    super.initState();
    getData();
  }

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
              top: ScreenUtil().setWidth(150),
              left: ScreenUtil().setWidth(40),
              child: Text(
                '选择收款人',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(48), color: Color(0xFF2F3B53)),
              )),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(278)),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: addresses != null ? addresses.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return PayeeItem(addresses[index]);
                }),
          )
        ],
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

class PayeeItem extends StatelessWidget {
  Address address;

  PayeeItem(this.address);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil().setWidth(194),
      alignment: Alignment.center,
      child: GestureDetector(
        child: Container(
          width: ScreenUtil().setWidth(670),
          height: ScreenUtil().setWidth(174),
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(174, 179, 208, 0.2),
                  blurRadius: ScreenUtil().setWidth(30),
                  offset: Offset(0, ScreenUtil().setWidth(5)))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12)),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: ScreenUtil().setWidth(44),
                  left: ScreenUtil().setWidth(30),
                  child: Text(
                    address.name,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(32),
                        color: Color(0xFF2F3B53),
                        fontWeight: FontWeight.w500),
                  )),
              Positioned(
                  top: ScreenUtil().setWidth(100),
                  left: ScreenUtil().setWidth(30),
                  child: Text(
                    address.address,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(22),
                        color: Color(0xFF95A2B3)),
                  ))
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context, address.address);
        },
      ),
    );
  }
}
