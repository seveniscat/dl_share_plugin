//
//  AppShareApi.m
//  share
//
//  Created by Bing on 2023/4/3.
//

#import "AppShareApi.h"
#import <WXApi.h>
#import <DTShareKit/DTOpenKit.h>
#import <Flutter/Flutter.h>
#import "AppShare.h"
#import "ThumbnailHelper.h"

//lazy var flutterApi: LockFlutterApi = {
//    let controller : FlutterViewController = UIApplication.shared.delegate?.window??.rootViewController as! FlutterViewController
//    return LockFlutterApi(binaryMessenger: controller.binaryMessenger)
//}()


@interface AppShareApi()


@end

@implementation AppShareApi

- (ShareFlutterApi *)flutterApi {
  if(_flutterApi == nil) {
    FlutterViewController *root = (FlutterViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [[ShareFlutterApi alloc] initWithBinaryMessenger:root.binaryMessenger];
  } else {
    return _flutterApi;
  }
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    static AppShareApi *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AppShareApi alloc] init];
    });
    return instance;
}

- (void)configAndroidPackagePackageName:(nonnull NSString *)packageName error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
  
}

- (nullable NSNumber *)isDingTalkInstalledWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
  return @([DTOpenAPI isDingTalkInstalled]);
}

- (void)isDingTalkSupportOpenAPIWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
  completion(@([DTOpenAPI isDingTalkSupportOpenAPI]), nil);
}

- (nullable NSNumber *)isWechatInstalledWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
  return @([WXApi isWXAppInstalled]);
}

- (nullable NSNumber *)registerWxAppId:(nonnull NSString *)appId universalLink:(nullable NSString *)universalLink error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
  return @([WXApi registerApp:appId universalLink:universalLink]);
}


- (nullable NSNumber *)registerDDAppId:(nonnull NSString *)appId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
  return @([DTOpenAPI registerApp:appId]);
}

- (nullable NSNumber *)startShareEnumContainer:(nonnull ShareEnumContainer *)enumContainer shareBody:(nonnull ShareBody *)shareBody error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
  NSData *imageData = [NSData dataWithContentsOfFile:shareBody.mLocalPath];
  if(enumContainer.sharePlatform.intValue == 2) {
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];
//    return @(YES);
    //  NSData *imageData = [NSData dataWithContentsOfFile:shareBody.mLocalPath];
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;

    WXMediaMessage *message = [WXMediaMessage message];
    message.thumbData = [self getThumbnailDataFromNSData:imageData size:6400 compress:YES];
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:^(BOOL success) { }];
  } else if(enumContainer.sharePlatform.intValue == 3) {
    // dingding
    DTSendMessageToDingTalkReq *sendMessageReq = [[DTSendMessageToDingTalkReq alloc] init];

    DTMediaMessage *mediaMessage = [[DTMediaMessage alloc] init];
    
    DTMediaImageObject *imgObject = [[DTMediaImageObject alloc] init];
    imgObject.imageData = imageData;
    
    mediaMessage.mediaObject = imgObject;
    sendMessageReq.message = mediaMessage;

    [DTOpenAPI sendReq:sendMessageReq];
  }
  return @(YES);
}

#pragma mark - 图片压缩
- (NSData *)getThumbnailDataFromNSData:(NSData *)data size:(NSUInteger)size compress:(BOOL)compress {
    if (compress) {
        return [ThumbnailHelper compressImageData:data toByte:size];
    } else {
        return data;
    }
}

@end
