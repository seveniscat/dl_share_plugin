// Autogenerated from Pigeon (v9.2.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "AppShare.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

@interface ShareBody ()
+ (ShareBody *)fromList:(NSArray *)list;
+ (nullable ShareBody *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@interface ShareEnumContainer ()
+ (ShareEnumContainer *)fromList:(NSArray *)list;
+ (nullable ShareEnumContainer *)nullableFromList:(NSArray *)list;
- (NSArray *)toList;
@end

@implementation ShareBody
+ (instancetype)makeWithMTitle:(nullable NSString *)mTitle
    mContent:(nullable NSString *)mContent
    mThumbUrl:(nullable NSString *)mThumbUrl
    mUrl:(nullable NSString *)mUrl
    shareType:(nullable NSNumber *)shareType
    mLocalPath:(nullable NSString *)mLocalPath {
  ShareBody* pigeonResult = [[ShareBody alloc] init];
  pigeonResult.mTitle = mTitle;
  pigeonResult.mContent = mContent;
  pigeonResult.mThumbUrl = mThumbUrl;
  pigeonResult.mUrl = mUrl;
  pigeonResult.shareType = shareType;
  pigeonResult.mLocalPath = mLocalPath;
  return pigeonResult;
}
+ (ShareBody *)fromList:(NSArray *)list {
  ShareBody *pigeonResult = [[ShareBody alloc] init];
  pigeonResult.mTitle = GetNullableObjectAtIndex(list, 0);
  pigeonResult.mContent = GetNullableObjectAtIndex(list, 1);
  pigeonResult.mThumbUrl = GetNullableObjectAtIndex(list, 2);
  pigeonResult.mUrl = GetNullableObjectAtIndex(list, 3);
  pigeonResult.shareType = GetNullableObjectAtIndex(list, 4);
  pigeonResult.mLocalPath = GetNullableObjectAtIndex(list, 5);
  return pigeonResult;
}
+ (nullable ShareBody *)nullableFromList:(NSArray *)list {
  return (list) ? [ShareBody fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.mTitle ?: [NSNull null]),
    (self.mContent ?: [NSNull null]),
    (self.mThumbUrl ?: [NSNull null]),
    (self.mUrl ?: [NSNull null]),
    (self.shareType ?: [NSNull null]),
    (self.mLocalPath ?: [NSNull null]),
  ];
}
@end

@implementation ShareEnumContainer
+ (instancetype)makeWithShareType:(nullable NSNumber *)shareType
    shareStatus:(nullable NSNumber *)shareStatus
    sharePlatform:(nullable NSNumber *)sharePlatform {
  ShareEnumContainer* pigeonResult = [[ShareEnumContainer alloc] init];
  pigeonResult.shareType = shareType;
  pigeonResult.shareStatus = shareStatus;
  pigeonResult.sharePlatform = sharePlatform;
  return pigeonResult;
}
+ (ShareEnumContainer *)fromList:(NSArray *)list {
  ShareEnumContainer *pigeonResult = [[ShareEnumContainer alloc] init];
  pigeonResult.shareType = GetNullableObjectAtIndex(list, 0);
  pigeonResult.shareStatus = GetNullableObjectAtIndex(list, 1);
  pigeonResult.sharePlatform = GetNullableObjectAtIndex(list, 2);
  return pigeonResult;
}
+ (nullable ShareEnumContainer *)nullableFromList:(NSArray *)list {
  return (list) ? [ShareEnumContainer fromList:list] : nil;
}
- (NSArray *)toList {
  return @[
    (self.shareType ?: [NSNull null]),
    (self.shareStatus ?: [NSNull null]),
    (self.sharePlatform ?: [NSNull null]),
  ];
}
@end

@interface ShareHostApiCodecReader : FlutterStandardReader
@end
@implementation ShareHostApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128: 
      return [ShareBody fromList:[self readValue]];
    case 129: 
      return [ShareEnumContainer fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface ShareHostApiCodecWriter : FlutterStandardWriter
@end
@implementation ShareHostApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[ShareBody class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else if ([value isKindOfClass:[ShareEnumContainer class]]) {
    [self writeByte:129];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface ShareHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation ShareHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[ShareHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[ShareHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *ShareHostApiGetCodec() {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    ShareHostApiCodecReaderWriter *readerWriter = [[ShareHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void ShareHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<ShareHostApi> *api) {
  ///注册DD
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.registerDD"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(registerDDAppId:error:)], @"ShareHostApi api (%@) doesn't respond to @selector(registerDDAppId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_appId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api registerDDAppId:arg_appId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  ///判断DD是否安装
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.isDingTalkInstalled"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isDingTalkInstalledWithError:)], @"ShareHostApi api (%@) doesn't respond to @selector(isDingTalkInstalledWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isDingTalkInstalledWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  ///注册微信
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.registerWx"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(registerWxAppId:universalLink:error:)], @"ShareHostApi api (%@) doesn't respond to @selector(registerWxAppId:universalLink:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_appId = GetNullableObjectAtIndex(args, 0);
        NSString *arg_universalLink = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api registerWxAppId:arg_appId universalLink:arg_universalLink error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.startShare"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startShareEnumContainer:shareBody:error:)], @"ShareHostApi api (%@) doesn't respond to @selector(startShareEnumContainer:shareBody:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        ShareEnumContainer *arg_enumContainer = GetNullableObjectAtIndex(args, 0);
        ShareBody *arg_shareBody = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSNumber *output = [api startShareEnumContainer:arg_enumContainer shareBody:arg_shareBody error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  ///微信是否安装
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.isWechatInstalled"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isWechatInstalledWithError:)], @"ShareHostApi api (%@) doesn't respond to @selector(isWechatInstalledWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api isWechatInstalledWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  ///指定安卓端包名
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.configAndroidPackage"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(configAndroidPackagePackageName:error:)], @"ShareHostApi api (%@) doesn't respond to @selector(configAndroidPackagePackageName:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_packageName = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api configAndroidPackagePackageName:arg_packageName error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  ///判断是否支持钉钉分享
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ShareHostApi.isDingTalkSupportOpenAPI"
        binaryMessenger:binaryMessenger
        codec:ShareHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(isDingTalkSupportOpenAPIWithCompletion:)], @"ShareHostApi api (%@) doesn't respond to @selector(isDingTalkSupportOpenAPIWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api isDingTalkSupportOpenAPIWithCompletion:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface ShareFlutterApiCodecReader : FlutterStandardReader
@end
@implementation ShareFlutterApiCodecReader
- (nullable id)readValueOfType:(UInt8)type {
  switch (type) {
    case 128: 
      return [ShareEnumContainer fromList:[self readValue]];
    default:
      return [super readValueOfType:type];
  }
}
@end

@interface ShareFlutterApiCodecWriter : FlutterStandardWriter
@end
@implementation ShareFlutterApiCodecWriter
- (void)writeValue:(id)value {
  if ([value isKindOfClass:[ShareEnumContainer class]]) {
    [self writeByte:128];
    [self writeValue:[value toList]];
  } else {
    [super writeValue:value];
  }
}
@end

@interface ShareFlutterApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation ShareFlutterApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[ShareFlutterApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[ShareFlutterApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *ShareFlutterApiGetCodec() {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    ShareFlutterApiCodecReaderWriter *readerWriter = [[ShareFlutterApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

@interface ShareFlutterApi ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation ShareFlutterApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)registerCallBackEnumContainer:(ShareEnumContainer *)arg_enumContainer completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.ShareFlutterApi.registerCallBack"
      binaryMessenger:self.binaryMessenger
      codec:ShareFlutterApiGetCodec()];
  [channel sendMessage:@[arg_enumContainer ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
- (void)isAppInstallCallBackIsInstall:(NSNumber *)arg_isInstall completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.ShareFlutterApi.isAppInstallCallBack"
      binaryMessenger:self.binaryMessenger
      codec:ShareFlutterApiGetCodec()];
  [channel sendMessage:@[arg_isInstall ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
- (void)shareCallBackEnumContainer:(ShareEnumContainer *)arg_enumContainer message:(NSString *)arg_message completion:(void (^)(FlutterError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.ShareFlutterApi.shareCallBack"
      binaryMessenger:self.binaryMessenger
      codec:ShareFlutterApiGetCodec()];
  [channel sendMessage:@[arg_enumContainer ?: [NSNull null], arg_message ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end

