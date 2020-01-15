// Objective-C API for talking to alpha.2se.com/sdk Go package.
//   gobind -lang=objc alpha.2se.com/sdk
//
// File is generated by gobind. Do not edit.

#ifndef __Sdk_H__
#define __Sdk_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


@class SdkJsonAccount;
@class SdkTransaction;

@interface SdkJsonAccount : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull address;
// skipped field JsonAccount.Balance with unsupported type: *math/big.Int

// skipped field JsonAccount.Nonce with unsupported type: uint64

@property (nonatomic) NSString* _Nonnull code;
@end

@interface SdkTransaction : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull hash;
@property (nonatomic) NSString* _Nonnull from;
@property (nonatomic) NSString* _Nonnull to;
@property (nonatomic) NSString* _Nonnull value;
@property (nonatomic) int64_t gas;
@property (nonatomic) NSString* _Nonnull gasPrice;
@property (nonatomic) NSData* _Nullable data;
@property (nonatomic) int64_t nonce;
@end

FOUNDATION_EXPORT const int64_t SdkBitSize;

@interface Sdk : NSObject
// skipped variable ChainID with unsupported type: *math/big.Int

+ (NSError* _Nullable) errInvalidChainId;
+ (void) setErrInvalidChainId:(NSError* _Nullable)v;

+ (NSError* _Nullable) errInvalidSig;
+ (void) setErrInvalidSig:(NSError* _Nullable)v;

@end

/**
 * ExportPrivateKey 导出私钥
如果生成失败，返回空字符串
参数
	json GeneratePrivateKey 返回结果第三个元素，keystore格式json字符串，不可以为空
	passphrase 加密keystore的密码，不可以为空

返回结果
	16进制的字符串，带0x前缀
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkExportPrivateKey(NSString* _Nullable json, NSString* _Nullable passphrase);

/**
 * ExportToMnemonicBip39 备份助记词
参数
	serialized 格式为GeneratePrivateKey 返回结果第四个元素，不可以为空
	passphrase string 解密json的密码 不可以为空字符串
返回结果
	boat tool couch gather typical mail school dragon text lobster belt alley
助记词之间以空格分隔的字符串，12个单词
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkExportToMnemonicBip39(NSString* _Nullable serialized, NSString* _Nullable passphrase);

/**
 * GeneratePrivateKey 生成私钥的方法,导出加密后的私钥
如果生成失败，返回空字符串
参数
	password string 用于对生成的私钥加密的密码，不可以为空

返回结果
	json string, 格式为四元数组。
	第一个元素是地址，带0x前缀的16进制字符串，42个字符
	第二个元素是公钥(压缩格式公钥)，带0x前缀的16进制字符串，68个字符
	第三个元素为keystore格式的json字符串，已经过passphrase加密
 第四个元素为助记词加密后的字符串，加密方式与keystore相同格式
	举个例子：
	[
		"0x8F55dAa29339bB9685019D57ba70A638FE0040d9",
		"0x02c42176372a9c30f29f04b99e2599f329f68b5f079d32834dad91203e41529694",
		"{\"address\":\"8f55daa29339bb9685019d57ba70a638fe0040d9\",\"crypto\":{\"cipher\":\"aes-128-ctr\",
	\"ciphertext\":\"5e5733e7b6778584c333088c4cb8c21aa303dbe1cad7182ab904c6593ef5ce51\",
	\"cipherparams\":{\"iv\":\"7c71f5614ce6c5491545348f352e6ce8\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,
	\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"068ff193018c6f53d66c4d1cd89c402321252b1f4bba9ec2826b88a092820be0\"},
	\"mac\":\"09291823e76575c7bdbe10b39a21a7dd9732ed5c00c42d8066ff5c0ac94d01c5\"},
	\"id\":\"97593094-bcd8-4bce-9f81-fe53726bd1a4\",\"version\":3",
		"{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"edfe032f7ab90b9157fc3fc905cbf7d9a6f73dcc51eee8dda07197945e5ad48b38adcea35fa57a4f29244509da3c4d1bdaad725fa58197c7f3bb22fe169ae6eddf23944ba1c9c29a33450c68b0\",\"cipherparams\":{\"iv\":\"c71f0f2e2ead371e688ee9ce1b9e00df\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"4fd4ad37fe0b933808d9a832cfdecb0e3022d55b199e402c4d9fc3477b525145\"},\"mac\":\"460b11fdad5a65295d76bdbc7c459dfcf050678036c9eadb7b5717aea1c2d72a\"}"
	]

返回结果由手机端解析，并保存。
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkGeneratePrivateKey(NSString* _Nullable passphrase);

/**
 * GetNonce 获取账号的当前nonce值
参数
	host 节点服务地址，如果为空默认为 http://localhost:8080,如要填写，遵照样例格式
	address 账户地址，如：0x3D5F11e6627422BFf4E5d8C8475d0c59C8521352
返回结果
	字符串格式的无符号整型。
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkGetNonce(NSString* _Nullable host, NSString* _Nullable address);

/**
 * ImportFromMnemonicBip39 从用户输入的助记词恢复密钥
参数
	mnemonic 助记词，格式以空格分隔的助记词，12个，不可以为空
 例如：boat tool couch gather typical mail school dragon text lobster belt alley
 alias 方便记忆的别名，可选
 passphrase 用户密码，不可以为空
返回结果
 同GeneratePrivateKey 方法返回结果一致。
	json string, 格式为四元数组。
	第一个元素是地址，带0x前缀的16进制字符串，42个字符
	第二个元素是公钥(压缩格式公钥)，带0x前缀的16进制字符串，68个字符
	第三个元素为keystore格式的json字符串，已经过passphrase加密
 第四个元素为助记词加密后的字符串，加密方式与keystore相同格式
	举个例子：
	[
		"0x8F55dAa29339bB9685019D57ba70A638FE0040d9",
		"0x02c42176372a9c30f29f04b99e2599f329f68b5f079d32834dad91203e41529694",
		"{\"address\":\"8f55daa29339bb9685019d57ba70a638fe0040d9\",\"crypto\":{\"cipher\":\"aes-128-ctr\",
	\"ciphertext\":\"5e5733e7b6778584c333088c4cb8c21aa303dbe1cad7182ab904c6593ef5ce51\",
	\"cipherparams\":{\"iv\":\"7c71f5614ce6c5491545348f352e6ce8\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,
	\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"068ff193018c6f53d66c4d1cd89c402321252b1f4bba9ec2826b88a092820be0\"},
	\"mac\":\"09291823e76575c7bdbe10b39a21a7dd9732ed5c00c42d8066ff5c0ac94d01c5\"},
	\"id\":\"97593094-bcd8-4bce-9f81-fe53726bd1a4\",\"version\":3",
		"{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"edfe032f7ab90b9157fc3fc905cbf7d9a6f73dcc51eee8dda07197945e5ad48b38adcea35fa57a4f29244509da3c4d1bdaad725fa58197c7f3bb22fe169ae6eddf23944ba1c9c29a33450c68b0\",\"cipherparams\":{\"iv\":\"c71f0f2e2ead371e688ee9ce1b9e00df\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"4fd4ad37fe0b933808d9a832cfdecb0e3022d55b199e402c4d9fc3477b525145\"},\"mac\":\"460b11fdad5a65295d76bdbc7c459dfcf050678036c9eadb7b5717aea1c2d72a\"}"
	]

返回结果由手机端解析，并保存。
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkImportFromMnemonicBip39(NSString* _Nullable sentense, NSString* _Nullable passphrase);

/**
 * ImportKeystore 导入json格式的字符串(keystore)
参数
	json 格式为GeneratePrivateKey 返回结果第三个元素 不可以为空字符串。由外部导入
	passphrase string 解密json的密码 不可以为空字符串
返回结果
	bool 导入成功 true，导入失败 false
	如果导入成功，手机客户端只需要保存json参数到本地。
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkImportKeystore(NSString* _Nullable serialized, NSString* _Nullable passphrase);

FOUNDATION_EXPORT BOOL SdkIsMnemonicValid(NSString* _Nullable mnemonic);

// skipped function SignContractTx with unsupported parameter or return types


/**
 * SignERC20Tx 调用标准BRC20的签名函数
tx 中的to，指向智能合约地址
函数中参数to指向要转到的人
value 转的数额，16进制
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkSignERC20Tx(NSString* _Nullable jsonKey, NSString* _Nullable pass, SdkTransaction* _Nullable tx, NSString* _Nullable to, NSString* _Nullable value);

/**
 * SignTx 用密钥对交易进行签名
⚠️注意，交易信息需要带上签名者账号的nonce值。
参数
 json 格式为GeneratePrivateKey 返回结果第三个元素 不可以为空字符串。
 passphrase 用户密码，不可以为空
	tx 交易信息，不可以为空
返回结果
	string， 签名后的原始签名信息，可直接提交给rawtx 的API接口
例如：
0xf88c0164830f4240943d5f11e6627422bff4e5d8c8475d0c59c8521352880de0b6b3a7640000808080
a000000000000000000000000000000000000000000000000000000000000000000125a031418c71547c
8c7fca5ee9c7bfca9972adfa843439a35a66c5e3398577ed905ba045d86042ddfca4a10373b0c97fc432
8d8dbce3170e1eb57e716784ec72d83701
 */
FOUNDATION_EXPORT NSString* _Nonnull SdkSignTx(NSString* _Nullable json, NSString* _Nullable passphrase, SdkTransaction* _Nullable tx);

#endif
