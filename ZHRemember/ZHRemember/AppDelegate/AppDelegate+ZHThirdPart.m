//
//  AppDelegate+ZHThirdPart.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AppDelegate+ZHThirdPart.h"
#import <AVOSCloud/AVOSCloud.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

#define AVOSCloudAppId @"OWMbwAs72wWfNRHS51jV5Tso-gzGzoHsz"
#define AVOSCloudAppkey @"LeFEoxaulIkxlIQx37YvadqU"

@implementation AppDelegate (ZHThirdPart)

- (void)zh_setupLeanCloudService{
    [AVOSCloud setApplicationId:AVOSCloudAppId clientKey:AVOSCloudAppkey];
    [AVOSCloud setAllLogsEnabled:NO];
}
- (void)zh_setupAdmobService{
    [GADMobileAds configureWithApplicationID:AdMobId];
    GADRequest *request = [GADRequest request];
    NSString *UnitId = [ZHCache isProductEnvironment] ? AdMobMovieId : AdMobMovieTestId;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:UnitId];
}
@end
