import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wallet/model/allow.dart';
import 'package:wallet/model/circle.dart';
import 'package:wallet/model/property.dart';
import 'package:wallet/model/token_info.dart';
import 'package:wallet/model/token_search_result.dart';
import 'package:wallet/model/transaction_history.dart';

///网络通信工具类
class NetUtils {
  static const String host = 'please use your own host';//请输入服务器域名
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  static Dio dio;

  static Dio getInstance() {
    if (dio == null) {
      dio = Dio(BaseOptions(
          baseUrl: host,
          connectTimeout: CONNECT_TIMEOUT,
          receiveTimeout: RECEIVE_TIMEOUT));
    }
    return dio;
  }

  static clear() {
    dio = null;
  }

  static Future<Response> get(String url, Map<String, dynamic> params) async {
    try {
      Dio dio = getInstance();
      return await dio.get(url, queryParameters: params);
    } on DioError catch (e) {
      if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
        return Future.error(Response(data: -1));
      } else {
        return Future.value(e.response);
      }
    }
  }

  static Future<Response> post(String url, Map<String, dynamic> params) async {
    try {
      Dio dio = getInstance();
      return await dio.post(url, queryParameters: params);
    } on DioError catch (e) {
      if (e.response.statusCode >= 300 && e.response.statusCode < 400) {
        return Future.error(Response(data: -1));
      } else {
        return Future.value(e.response);
      }
    }
  }

  static Future<Response> postJson(String url, String params) async {
    print('postJson url $url');
    try {
      Dio dio = getInstance();
      return await dio.post(url, data: params);
    } on DioError catch (e) {
      if (e.response != null &&
          e.response.statusCode >= 300 &&
          e.response.statusCode < 400) {
        return Future.error(Response(data: -1));
      } else {
        return Future.value(e.response);
      }
    }
  }

  ///获取资产
  static Future<Property> getProperty(String address) async {
    print('getProperty address $address');
    Map<String, dynamic> params = {
      'data': {'addr': address},
      'sign': 'signedstring'
    };

    Response response = await postJson('/asset/getbalance', jsonEncode(params));
    print('getProperty response $response');
    return Property.fromMap(response.data['data']);
  }

  ///获取交易记录
  static Future<TransactionHistory> getHistory(
      String address, int page, int pageSize) async {
    print('getHistory address $address page $page pageSize $pageSize');
    Map<String, dynamic> params = {
      'data': {'addr': address, 'page': page, 'page_size': pageSize},
      'sign': 'signedstring'
    };

    Response response = await postJson('/tx/gethistory', jsonEncode(params));
    print('response $response');
    if (response != null && response.data['err_code'] == 10001) {
      return TransactionHistory.fromMap(response.data['data']);
    }
    return null;
  }

  ///发送交易
  static Future<bool> deal(String address, String dealData) async {
    print('deal address $address');
    print('deal dealData $dealData');
    Map<String, dynamic> params = {
      'data': {'addr': address, 'signed_tx': dealData},
      'sign': 'signedstring'
    };

    Response response = await postJson('/tx/sendtx', jsonEncode(params));
    print('response $response');
    return response.data['err_code'] == 10001;
  }

  ///获取资产  address 自己的地址
  static Future<String> getNonce(String address) async {
    print('getNonce address $address');
    Map<String, dynamic> params = {
      'data': {'addr': address},
      'sign': 'signedstring'
    };

    Response response = await postJson('/asset/getnonce', jsonEncode(params));
    print('response $response');
    if (response.data['err_code'] == 10001) {
      return response.data['data']['nonce'].toString();
    }
    return "0";
  }

  ///检测圈子可否添加
  static Future<Allow> checkJoin(String address) async {
    Map<String, dynamic> params = {
      'data': {'addr': address},
      'sign': 'signedstring'
    };

    Response response = await postJson('/league/checkjoin', jsonEncode(params));
    print('response $response');
    if (response.data['err_code'] == 10001) {
      return Allow.fromMap(response.data['data']);
    }
    return null;
  }

  ///默认圈子获取
  static Future<Circle> getDefaultLeague(String address) async {
    print('getDefaultLeague address $address');
    Map<String, dynamic> params = {
      'data': {'addr': address},
      'sign': 'signedstring'
    };

    Response response =
        await postJson('/league/getdefaultleague', jsonEncode(params));
    print('response $response');
    if (response != null && response.data['err_code'] == 10001) {
      return Circle.fromMap(response.data['data']);
    }
    return null;
  }

  ///搜索token
  static Future<TokenSearchResult> searchToken(
      String address, String word) async {
    print('searchToken address $address word $word');
    Map<String, dynamic> params = {
      'data': {'addr': address, 'content': word},
      'sign': 'signedstring'
    };

    Response response =
        await postJson('/asset/searchtoken', jsonEncode(params));
    print('response $response');
    if (response.data['err_code'] == 10001) {
      return TokenSearchResult.fromMap(response.data['data']);
    }
    return null;
  }

  ///关注token
  static Future<bool> followToken(String address, String contract) async {
    Map<String, dynamic> params = {
      'data': {'addr': address, 'contract': contract},
      'sign': 'signedstring'
    };

    Response response =
        await postJson('/asset/followtoken', jsonEncode(params));
    print('response $response');
    return response.data['err_code'] == 10001;
  }

  ///获取子币资产
  static Future<TokenInfo> getTokenInfo(
      String address, String contract, int page, int pageSize) async {
    print(
        'getTokenInfo address $address contract $contract page $page pageSize $pageSize');
    Map<String, dynamic> params = {
      'data': {
        'addr': address,
        'contract': contract,
        'page': page,
        'page_size': pageSize
      },
      'sign': 'signedstring'
    };

    Response response = await postJson('/asset/tokeninfo', jsonEncode(params));
    print('response $response');
    if (response != null && response.data['err_code'] == 10001) {
      return TokenInfo.fromMap(response.data['data']);
    }
    return null;
  }
}
