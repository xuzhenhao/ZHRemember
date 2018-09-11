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

#define AVOSCloudAppTestId @"OWMbwAs72wWfNRHS51jV5Tso-gzGzoHsz"
#define AVOSCloudAppTestkey @"LeFEoxaulIkxlIQx37YvadqU"

#define AVOSCloudAppId @"Rv5XVMDxCfhGBekEcGENDBoE-gzGzoHsz"
#define AVOSCloudAppkey @"y3cttoOTBQ4d4yc8Ccoood8l"

@implementation AppDelegate (ZHThirdPart)

- (void)zh_setupLeanCloudService{
    if ([ZHCache isProductEnvironment]) {
        [AVOSCloud setApplicationId:AVOSCloudAppId clientKey:AVOSCloudAppkey];
    }else{
        [AVOSCloud setApplicationId:AVOSCloudAppTestId clientKey:AVOSCloudAppTestkey];
    }
    
    [AVOSCloud setAllLogsEnabled:NO];
}
- (void)zh_setupAdmobService{
    [GADMobileAds configureWithApplicationID:AdMobId];
    GADRequest *request = [GADRequest request];
    NSString *UnitId = [ZHCache isProductEnvironment] ? AdMobMovieId : AdMobMovieTestId;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                           withAdUnitID:UnitId];
}
- (void)zh_setupLocalPushService{
    //通知授权
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
    // 获取该app上所有的本地推送
    NSArray *allLocalNotifi = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (allLocalNotifi.count < 1) {
        [self addLocalPush];
    }
    
}
- (void)addLocalPush{
    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
    // 设置触发时间
    localNotifi.fireDate = [NSDate dateWithString:@"21:30:00" formatString:@"HH:mm:ss"];
    // 设置时区  以当前手机运行的时区为准
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    // 设置推送 显示的内容
    localNotifi.alertTitle = @"温馨提示";
    localNotifi.alertBody = @"今天有什么想记得的呢?";
    localNotifi.alertAction = @"alert提示框按钮文本";
    //是否显示额外的按钮，为no时alertAction消失
    localNotifi.hasAction = NO;
    // 设置 icon小红点个数
    localNotifi.applicationIconBadgeNumber = 0;
    // 设置是否重复  重复最小时间间隔为秒，但最好是分钟
    // 不设置此属性，则默认不重复
    localNotifi.repeatInterval =  NSCalendarUnitDay;
    // 设置推送的声音
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    // 设置推送的区别符
    localNotifi.userInfo = @{@"name":@"loaclPushOne"};
    // 按照前面设置的计划 执行此通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
}
- (void)deleteLocalPush{
    // 获取该app上所有的本地推送
    NSArray *allLocalNotifi = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    // 取消特定的本地推送
    UILocalNotification *localNotifi  = nil;
    for (UILocalNotification *item in allLocalNotifi) {
        NSDictionary *userInfo = item.userInfo;
        if ([[userInfo objectForKey:@"name"] isEqualToString:@"loaclPushOne"]) {
            localNotifi = item;
            break;
        }
    }
    [[UIApplication sharedApplication] cancelLocalNotification:localNotifi];
}
@end
