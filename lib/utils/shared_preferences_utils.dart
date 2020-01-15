import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static final String sp_wallet = '';

  ///当前钱包的地址
  static final String sp_current_wallet = 'currentWallet';

  static Future<String> getCurrentWalletAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(sp_current_wallet);
  }

  static Future setCurrentWalletAddress(String address) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(sp_current_wallet, address);
  }
}
