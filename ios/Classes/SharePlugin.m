#import "SharePlugin.h"
#import "AppShareApi.h"
#import <WXApi.h>
#import <DTShareKit/DTOpenKit.h>

@interface AppWxShareManager : NSObject<WXApiDelegate>
+ (instancetype)defaultManager;

@end
@implementation AppWxShareManager
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static AppWxShareManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AppWxShareManager alloc] init];
    });
    return instance;
}
- (void)onReq:(BaseReq *)req {}
- (void)onResp:(BaseResp *)resp{
    ShareEnumContainer * obj = [[ShareEnumContainer alloc] init];
    obj.sharePlatform = @2;
    obj.shareType = @2;
    obj.shareStatus = (resp.errCode == 0) ? @1 : @2;
    
    [[[AppShareApi sharedInstance] flutterApi]  shareCallBackEnumContainer:obj message:@"" completion:^(FlutterError * _Nullable _) {}];
}

@end

@interface AppDingShareManager : NSObject<DTOpenAPIDelegate>
+ (instancetype)defaultManager;

@end
@implementation AppDingShareManager
+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static AppDingShareManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AppDingShareManager alloc] init];
    });
    return instance;
}

- (void)onReq:(DTBaseReq *)req {
}
- (void)onResp:(DTBaseResp *)resp {
    ShareEnumContainer * obj = [[ShareEnumContainer alloc] init];
    obj.sharePlatform = @3;
    obj.shareType = @2;
    obj.shareStatus = (resp.errorCode == 0) ? @1 : @2;
    [[[AppShareApi sharedInstance] flutterApi]  shareCallBackEnumContainer:obj message:@"" completion:^(FlutterError * _Nullable _) {}];

}

@end


@implementation SharePlugin
FlutterMethodChannel *channel = nil;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
//        NSLog(@"WeChatSDK: %@", log);
//    }];
    
    ShareHostApiSetup([registrar messenger], [AppShareApi sharedInstance]);
    //  [registrar addApplicationDelegate:[[SharePlugin alloc] init]];
    
    if (channel == nil) {
        channel = [FlutterMethodChannel
                   methodChannelWithName:@"com.shdatalink/application"
                   binaryMessenger:[registrar messenger]];
        SharePlugin *instance = [[SharePlugin alloc] init];
        [registrar addMethodCallDelegate:instance channel:channel];
        [registrar addApplicationDelegate:instance];
    }
    
}

- (BOOL)handleOpenURL:(NSNotification *)aNotification {
    NSString *aURLString = [aNotification userInfo][@"url"];
    NSURL *aURL = [NSURL URLWithString:aURLString];
    if([DTOpenAPI handleOpenURL:aURL delegate:[AppDingShareManager defaultManager]]) {
      return YES;
    }else if([WXApi handleOpenURL:aURL delegate:[AppWxShareManager defaultManager]]) {
      return YES;
    }
    return NO;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if([DTOpenAPI handleOpenURL:url delegate:[AppDingShareManager defaultManager]]) {
      return YES;
    }else if([WXApi handleOpenURL:url delegate:[AppWxShareManager defaultManager]]) {
      return YES;
    }
    return NO;

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  if([DTOpenAPI handleOpenURL:url delegate:[AppDingShareManager defaultManager]]) {
    return YES;
  }else if([WXApi handleOpenURL:url delegate:[AppWxShareManager defaultManager]]) {
    return YES;
  }
  return NO;
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nonnull))restorationHandler{
  return [WXApi handleOpenUniversalLink:userActivity delegate:[AppWxShareManager defaultManager]];
}
- (void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity  API_AVAILABLE(ios(13.0)){
    [WXApi handleOpenUniversalLink:userActivity delegate:[AppWxShareManager defaultManager]];
}

@end

