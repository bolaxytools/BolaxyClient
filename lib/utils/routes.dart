import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wallet/utils/router_handler.dart';

class Routes {
  static String root = "/";
  static String bottomNavigation = "/bottomNavigation";
  static String newAddress = "/new_address";
  static String transfer = "/transfer";
  static String selectPayee = "/selectPayee";
  static String circleSetting = "/circleSetting";
  static String addCircle = "/addCircle";
  static String manageWallet = "/manageWallet";
  static String exportWallet = "/exportWallet";
  static String createOrImport = "/createOrImport";
  static String createWallet = "/createWallet";
  static String importWallet = "/importWallet";
  static String backupWallet = "/backupWallet";
  static String backupMnemonicWord = "/backupMnemonicWord";
  static String affirmMnemonicWord = "/affirmMnemonicWord";
  static String transferDetail = "/transferDetail";
  static String gathering = "/gathering";
  static String coinDetail = "/coinDetail";
  static String circleDetail = "/circleDetail";
  static String browser = "/web";
  static String addToken = "/addToken";

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('ERROR====>ROUTE WAS NOT FONUND!!!');
    });

    router.define(bottomNavigation, handler: bottomNavigationHandler);
    router.define(newAddress, handler: newAddressHandler);
    router.define(transfer, handler: transferHandler);
    router.define(selectPayee, handler: selectPayeeHandler);
    router.define(circleSetting, handler: circleSettingHandler);
    router.define(addCircle, handler: addCircleHandler);
    router.define(manageWallet, handler: manageWalletHandler);
    router.define(exportWallet, handler: exportWalletHandler);
    router.define(createOrImport, handler: createOrImportHandler);
    router.define(createWallet, handler: createWalletHandler);
    router.define(importWallet, handler: importWalletHandler);
    router.define(backupWallet, handler: backupWalletHandler);
    router.define(backupMnemonicWord, handler: backupMnemonicWordHandler);
    router.define(affirmMnemonicWord, handler: affirmMnemonicWordHandler);
    router.define(transferDetail, handler: transferDetailHandler);
    router.define(gathering, handler: gatheringHandler);
    router.define(coinDetail, handler: coinDetailHandler);
    router.define(circleDetail, handler: circleDetailHandler);
    router.define(browser, handler: browserHandler);
    router.define(addToken, handler: addTokenHandler);
  }
}
