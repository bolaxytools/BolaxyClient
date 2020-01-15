import 'package:flutter/material.dart';
import 'package:wallet/pages/address_book_page.dart';
import 'package:wallet/pages/home_page.dart';
import 'package:wallet/pages/mine_page.dart';

///主页底部导航栏
class BottomNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<Widget> pageList = List();
  int _currentIndex = 0;

  @override
  void initState() {
    pageList..add(HomePage())
      ..add(AddressBookPage())
      ..add(MinePage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: const Color(0xFFD6DDE6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/homepange_highlight.png')),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/address_highlight.png')),
            title: Text('地址簿'),
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/mine_highlight.png')),
            title: Text('我的'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: pageList[_currentIndex],
    );
  }
}
