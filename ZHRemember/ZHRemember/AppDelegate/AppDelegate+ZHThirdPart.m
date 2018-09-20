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
#import "ZHPushManager.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

#define AVOSCloudAppTestId @"OWMbwAs72wWfNRHS51jV5Tso-gzGzoHsz"
#define AVOSCloudAppTestkey @"LeFEoxaulIkxlIQx37YvadqU"

#define AVOSCloudAppId @"Rv5XVMDxCfhGBekEcGENDBoE-gzGzoHsz"
#define AVOSCloudAppkey @"y3cttoOTBQ4d4yc8Ccoood8l"

#define UMengAppId @"5ba31320b465f56c140000bc"

@implementation AppDelegate (ZHThirdPart)

- (void)zh_setupUmengService{
    [UMConfigure initWithAppkey:UMengAppId channel:@"App Store"];
}
- (void)zh_setupLeanCloudService{
    if ([ZHGlobalStore isProductEnvironment]) {
        [AVOSCloud setApplicationId:AVOSCloudAppId clientKey:AVOSCloudAppkey];
    }else{
        [AVOSCloud setApplicationId:AVOSCloudAppTestId clientKey:AVOSCloudAppTestkey];
    }
    
    [AVOSCloud setAllLogsEnabled:NO];
}
- (void)zh_setupAdmobService{
    [GADMobileAds configureWithApplicationID:AdMobId];
    GADRequest *request = [GADRequest request];
    NSString *UnitId = [ZHGlobalStore isProductEnvironment] ? AdMobMovieId : AdMobMovieTestId;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:UnitId];
}
- (void)zh_setupLocalPushService{
    //通知授权
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    //本地提醒
    [ZHPushManager addLocalPushWithName:@"loaclPushOne" date:[NSDate dateWithYear:2018 month:1 day:1 hour:[ZHGlobalStore getDiaryPushHour] minute:[ZHGlobalStore getDiaryPushMinute] second:0] shouldRepead:YES repeat:NSCalendarUnitDay message:@"今天你记了吗?"];
}

#pragma mark - utils
- (void)_getDeviceId{
    //如果用户用组件化SDK,需要升级最新的UMCommon.framework版本。
    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@",deviceID);
}
@end
