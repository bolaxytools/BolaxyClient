import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wallet/lang/config.dart';
import 'package:wallet/lang/index.dart'
    show AppLocalizations, AppLocalizationsDelegate;

import 'Application.dart';
import 'pages/splash_page.dart';
import 'utils/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final router = Router();

  // 定义全局 语言代理
  AppLocalizationsDelegate _delegate;

  @override
  void initState() {
    init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //多语言
    _delegate = AppLocalizationsDelegate();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      onGenerateRoute: Application.router.generator,
//      localeResolutionCallback: (deviceLocale, supportedLocal) {
//        print(
//            '当前设备语种 deviceLocale: $deviceLocale, 支持语种 supportedLocale: $supportedLocal}');
//        // 判断传入语言是否支持
//        Locale _locale = supportedLocal.contains(deviceLocale)
//            ? deviceLocale
//            : Locale('zh', 'CN');
//        return _locale;
//      },
//      localizationsDelegates: [
//        GlobalMaterialLocalizations.delegate,
//        // 为Material Components库提供本地化的字符串和其他值
//        GlobalWidgetsLocalizations.delegate,
//        // 定义widget默认的文本方向，从左往右或从右往左
//        _delegate
//      ],
//      supportedLocales: ConfigLanguage.supportedLocales,
    );
  }

  void init() {
    Application.init();

    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // went to Background
      Application.release();
    }
    if (state == AppLifecycleState.resumed) {
      // came back to Foreground
    }
  }
}
