// Autogenerated from Pigeon (v9.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class ShareBody;
@class ShareEnumContainer;

@interface ShareBody : NSObject
+ (instancetype)makeWithMTitle:(nullable NSString *)mTitle
    mContent:(nullable NSString *)mContent
    mThumbUrl:(nullable NSString *)mThumbUrl
    mUrl:(nullable NSString *)mUrl
    shareType:(nullable NSNumber *)shareType
    mLocalPath:(nullable NSString *)mLocalPath;
@property(nonatomic, copy, nullable) NSString * mTitle;
/// 内容
@property(nonatomic, copy, nullable) NSString * mContent;
/// 缩略图链接
@property(nonatomic, copy, nullable) NSString * mThumbUrl;
/// 网页分享的连接地址
@property(nonatomic, copy, nullable) NSString * mUrl;
@property(nonatomic, strong, nullable) NSNumber * shareType;
@property(nonatomic, copy, nullable) NSString * mLocalPath;
@end

@interface ShareEnumContainer : NSObject
+ (instancetype)makeWithShareType:(nullable NSNumber *)shareType
    shareStatus:(nullable NSNumber *)shareStatus
    sharePlatform:(nullable NSNumber *)sharePlatform;
@property(nonatomic, strong, nullable) NSNumber * shareType;
@property(nonatomic, strong, nullable) NSNumber * shareStatus;
@property(nonatomic, strong, nullable) NSNumber * sharePlatform;
@end

/// The codec used by ShareHostApi.
NSObject<FlutterMessageCodec> *ShareHostApiGetCodec(void);

/// flutter调用 原生端的方法集
@protocol ShareHostApi
/// 注册DD
///
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)registerDDAppId:(NSString *)appId error:(FlutterError *_Nullable *_Nonnull)error;
/// 判断DD是否安装
///
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isDingTalkInstalledWithError:(FlutterError *_Nullable *_Nonnull)error;
/// 注册微信
///
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)registerWxAppId:(NSString *)appId universalLink:(nullable NSString *)universalLink error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)startShareEnumContainer:(ShareEnumContainer *)enumContainer shareBody:(ShareBody *)shareBody error:(FlutterError *_Nullable *_Nonnull)error;
/// 微信是否安装
///
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isWechatInstalledWithError:(FlutterError *_Nullable *_Nonnull)error;
///指定安卓端包名
- (void)configAndroidPackagePackageName:(NSString *)packageName error:(FlutterError *_Nullable *_Nonnull)error;
///判断是否支持钉钉分享
- (void)isDingTalkSupportOpenAPIWithCompletion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
@end

extern void ShareHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<ShareHostApi> *_Nullable api);

/// The codec used by ShareFlutterApi.
NSObject<FlutterMessageCodec> *ShareFlutterApiGetCodec(void);

/// 原生端调用flutter的方法集
@interface ShareFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
///注册回调
- (void)registerCallBackEnumContainer:(ShareEnumContainer *)enumContainer completion:(void (^)(FlutterError *_Nullable))completion;
- (void)isAppInstallCallBackIsInstall:(NSNumber *)isInstall completion:(void (^)(FlutterError *_Nullable))completion;
///分享回调
- (void)shareCallBackEnumContainer:(ShareEnumContainer *)enumContainer message:(NSString *)message completion:(void (^)(FlutterError *_Nullable))completion;
@end

NS_ASSUME_NONNULL_END
