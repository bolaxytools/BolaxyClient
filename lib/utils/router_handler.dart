import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wallet/pages/add_circle_page.dart';
import 'package:wallet/pages/add_token.dart';
import 'package:wallet/pages/browser_page.dart';
import 'package:wallet/pages/circle/circle_detail_page.dart';
import 'package:wallet/pages/circle_setting_page.dart';
import 'package:wallet/pages/coin_detail_page.dart';
import 'package:wallet/pages/create/affirm_mnemonic_word_page.dart';
import 'package:wallet/pages/create/backup_mnemonic_word_page.dart';
import 'package:wallet/pages/create/backup_wallet_page.dart';
import 'package:wallet/pages/create/create_or_import_page.dart';
import 'package:wallet/pages/create/create_wallet_page.dart';
import 'package:wallet/pages/export_wallet.dart';
import 'package:wallet/pages/gathering_page.dart';
import 'package:wallet/pages/import_wallet/import_wallet_page.dart';
import 'package:wallet/pages/manage_wallet_page.dart';
import 'package:wallet/pages/new_address_page.dart';
import 'package:wallet/pages/select_payee_page.dart';
import 'package:wallet/pages/transfer_detail_page.dart';
import 'package:wallet/pages/transfer_page.dart';
import 'package:wallet/widgets/bottom_navigation.dart';

Handler newAddressHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return NewAddressPage();
});

Handler bottomNavigationHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return BottomNavigation();
});

Handler transferHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String symbol = params['symbol']?.first;
  String balance = params['balance']?.first;
  String address = params['address']?.first;
  String bap = params['bap']?.first;
  String contract = params['contract']?.first;
  String decimals = params['decimals']?.first;
  print('transferHandler decimals $decimals');
  return TransferPage(symbol, balance, address, bap,
      contract: contract, decimals: decimals);
});

Handler selectPayeeHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return SelectPayeePage();
});

Handler circleSettingHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CircleSettingPage();
});

Handler addCircleHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String circleString = params['circle_string']?.first;
  return AddCirclePage(circleString);
});

Handler manageWalletHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ManageWalletPage();
});

Handler exportWalletHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String keyStore = params['key_store']?.first;
  return ExportWallet(keyStore);
});

Handler createOrImportHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CreateOrImportPage();
});

Handler createWalletHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return CreateWalletPage();
});

Handler importWalletHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return ImportWalletPage();
});

Handler backupWalletHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String walletName = params['name']?.first;
  String walletPassword = params['password']?.first;
  return BackupWalletPage(walletName, walletPassword);
});

Handler backupMnemonicWordHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String walletName = params['name']?.first;
  String walletPassword = params['password']?.first;
  return BackupMnemonicWordPage(walletName, walletPassword);
});

Handler affirmMnemonicWordHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String walletName = params['name']?.first;
  String walletPassword = params['password']?.first;
  return AffirmMnemonicWordPage(walletName, walletPassword);
});

Handler transferDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TransferDetailPage();
});

Handler gatheringHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return GatheringPage();
});

Handler coinDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  print('params $params');
  String name = params['name']?.first;
  String balance = params['balance']?.first;
  String contract = params['contract']?.first;
  print('contract $contract');

  return CoinDetailPage(name, balance, contract);
});

Handler circleDetailHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String chainId = params['chain_id']?.first;
  String walletAddress = params['wallet_address']?.first;
  return CircleDetailPage(chainId, walletAddress);
});

Handler browserHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String url = params['url']?.first;
  String title = params['title']?.first;
  print('browserHandler url $url');
  print('browserHandler title $title');
  return Browser(url, title);
});

Handler addTokenHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return AddToken();
});
