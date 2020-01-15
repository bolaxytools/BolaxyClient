import 'dart:math' as prefix0;

class StringUtils {
  static String formatNum(num, {point: 3}) {
    try {
      if (num != null) {
        String str = double.parse(num.toString()).toString();
        // 分开截取
        List<String> sub = str.split('.');
        // 处理值
        List val = List.from(sub[0].split(''));
        // 处理点
        List<String> points = List();
        if(sub.length > 1){
          points = List.from(sub[1].split(''));
        }
        //处理分割符
        for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
          // 除以三没有余数、不等于零并且不等于1 就加个逗号
          if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
        }
        // 处理小数点
        for (int i = 0; i <= point - points.length; i++) {
          points.add('0');
        }
        //如果大于长度就截取
        if (points.length > point) {
          // 截取数组
          points = points.sublist(0, point);
        }
        // 判断是否有长度
        if (points.length > 0) {
          return '${val.join('')}.${points.join('')}';
        } else {
          return val.join('');
        }
      } else {
        return "0.0";
      }
    } catch (e) {
      return "0.0";
    }
  }

  ///获取显示的财产金额，将字符串 转为数字 除以 10的18次方 添加小数点
  static String getProperty(String numString, {point: 3}) {
//    print('getProperty numString $numString');
    num number = num.parse(numString);
    num result = BigInt.from(number) / BigInt.from(prefix0.pow(10, 18));
    return formatNum(result.toString(), point: point);
  }
}
