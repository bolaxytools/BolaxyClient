import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///加载更多
class LoadMore extends StatelessWidget {
  bool isHaveMore = true;

  LoadMore(this.isHaveMore);

  @override
  Widget build(BuildContext context) {
    if (isHaveMore) {
      return Container(
        height: ScreenUtil().setWidth(60),
        alignment: Alignment.center,
        child: Text('加载中...'),
      );
    } else {
      return Container(
        height: ScreenUtil().setWidth(60),
        alignment: Alignment.center,
        child: Text('已无更多'),
      );
    }
  }
}
