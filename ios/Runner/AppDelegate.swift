import UIKit
import Flutter
import Sdk

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
    let userdefault = FlutterMethodChannel.init(name: "com.twose.wallet",
                                                binaryMessenger: controller.binaryMessenger);
    
    userdefault.setMethodCallHandler { (call, result) in
        //       platresult = await platform.invokeMethod(/*cell.method*/'setToken',/*cell.arguments*/"我是一个token",);
        if "setToken" == call.method{
            self.setPlatString(result: result, tokenStr: call.arguments as! String)
        }
        else if "getString" == call.method{
//            self.getPlatString(result: result)
            result("ios result")
            
        }
        else if "generatePrivateKey" == call.method{

            let privateKey = SdkGeneratePrivateKey(call.arguments as! String)
            
            result(privateKey)
        }
        else if "getMnemonicWords" == call.method{
            let json:Data = (call.arguments as! String).data(using: .utf8)!
            let dict = try? JSONSerialization.jsonObject(with: json, options: .mutableContainers)
            let nsdict = dict as! NSDictionary

            let word = SdkExportToMnemonicBip39(nsdict.value(forKey: "serialized") as! String, nsdict.value(forKey: "password") as! String)
                        
            result(word)
        } else if "generateTransaction" == call.method {
            let json:Data = (call.arguments as! String).data(using: .utf8)!
            let dict = try? JSONSerialization.jsonObject(with: json, options: .mutableContainers)
            let nsdict = dict as! NSDictionary
            
            let transaction = SdkTransaction()
            transaction.from = nsdict.value(forKey: "from") as! String
            transaction.gasPrice = nsdict.value(forKey: "gasPrice") as! String
            transaction.to = nsdict.value(forKey: "to") as! String
            transaction.value = nsdict.value(forKey: "value") as! String
            transaction.nonce = Int64(nsdict.value(forKey: "nonce") as! String)!
            transaction.gas = Int64(nsdict.value(forKey: "gas") as! String)!

            let word = SdkSignTx(nsdict.value(forKey: "json") as! String, nsdict.value(forKey: "password") as! String,transaction)
            result(word)
        } else if "importFromMnemonic" == call.method {
            let json:Data = (call.arguments as! String).data(using: .utf8)!
            let dict = try? JSONSerialization.jsonObject(with: json, options: .mutableContainers)
            let nsdict = dict as! NSDictionary
            
            let privateKey = SdkImportFromMnemonicBip39(nsdict.value(forKey: "mnemonic") as! String, nsdict.value(forKey: "password") as! String)
            result(privateKey)
         } else if "importKeystore" == call.method {
            let json:Data = (call.arguments as! String).data(using: .utf8)!
            let dict = try? JSONSerialization.jsonObject(with: json, options: .mutableContainers)
            let nsdict = dict as! NSDictionary
            let privateKey = SdkImportKeystore(nsdict.value(forKey: "keystore") as! String, nsdict.value(forKey: "password") as! String)
            result(privateKey)
        } else if "signERC20Tx" == call.method {
            let json:Data = (call.arguments as! String).data(using: .utf8)!
            let dict = try? JSONSerialization.jsonObject(with: json, options: .mutableContainers)
            let nsdict = dict as! NSDictionary
            
            let transaction = SdkTransaction()
            transaction.from = nsdict.value(forKey: "from") as! String
            transaction.gasPrice = nsdict.value(forKey: "gasPrice") as! String
            transaction.to = nsdict.value(forKey: "toChain") as! String
            transaction.value = nsdict.value(forKey: "value") as! String
            transaction.nonce = Int64(nsdict.value(forKey: "nonce") as! String)!
            transaction.gas = Int64(nsdict.value(forKey: "gas") as! String)!

            let word = SdkSignERC20Tx(nsdict.value(forKey: "json") as! String, nsdict.value(forKey: "password") as! String, transaction, nsdict.value(forKey: "to") as! String, nsdict.value(forKey: "unit") as! String)
            result(word)
        } else if "checkMnemonic" == call.method {
            let isValid = SdkIsMnemonicValid(call.arguments as! String)
            result(isValid)
        }
        else{
            result(FlutterMethodNotImplemented)
        }
        

    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    fileprivate func getPlatString(result:FlutterResult){
          let token:String = UserDefaults.standard.value(forKey: "token") as! String
          result(token)
        result("ios result getPlatString")
      }
    fileprivate func setPlatString(result:FlutterResult,tokenStr:String){
          UserDefaults.standard.set(tokenStr, forKey: "token")
          UserDefaults.standard.synchronize()
          result(NSNumber(booleanLiteral: true))
     }
}
