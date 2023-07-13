//
//  AppShareApi.h
//  share
//
//  Created by Bing on 2023/4/3.
//

#import <Foundation/Foundation.h>
#import "AppShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppShareApi : NSObject<ShareHostApi>
@property (nonatomic ,strong) ShareFlutterApi *flutterApi;

+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
