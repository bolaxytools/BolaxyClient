
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

///打开摄像头扫描的工具类
class ScanUtils {
  static Future<String> scan() {
    return requestPermission();
  }

  static Future<String> toScan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      String barcode = await BarcodeScanner.scan();
      print('扫码结果: ' + barcode);
      return barcode;
    } on PlatformException catch (e) {
      print('扫码错误: e.code ${e.code}');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // 未授予APP相机权限
        print('未授予APP相机权限');
      } else {
        // 扫码错误
        print('扫码错误: $e');
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      print('进入扫码页面后未扫码就返回');
    } catch (e) {
      // 扫码错误
      print('扫码错误: $e');
    }
  }

  static Future<String> requestPermission() async {
    // 申请权限
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    // 申请结果
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.granted) {
      return toScan();
    } else {

//      SystemChannels.platform.name
//      if(Platform.isAndroid){
//
//      } else {
//
//      }
      Fluttertoast.showToast(msg: "权限申请被拒绝");
    }
  }
}
