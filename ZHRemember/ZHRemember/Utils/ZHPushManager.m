//
//  ZHPushManager.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHPushManager.h"

@implementation ZHPushManager

+ (void)addLocalPushWithName:(NSString *)name date:(NSDate *)date shouldRepead:(BOOL)shouldRepeat repeat:(NSCalendarUnit)type message:(NSString *)msg{
    [self deleteLocalPushWithName:name];
    
    UILocalNotification *localNotifi = [[UILocalNotification alloc]init];
    // 设置触发时间
    localNotifi.fireDate = date;
    // 设置时区  以当前手机运行的时区为准
    localNotifi.timeZone = [NSTimeZone defaultTimeZone];
    // 设置推送 显示的内容
    localNotifi.alertTitle = @"温馨提示";
    localNotifi.alertBody = msg;
    localNotifi.alertAction = @"alert提示框按钮文本";
    //是否显示额外的按钮，为no时alertAction消失
    localNotifi.hasAction = NO;
    // 设置 icon小红点个数
    localNotifi.applicationIconBadgeNumber = 0;
    // 设置是否重复  重复最小时间间隔为秒，但最好是分钟
    // 不设置此属性，则默认不重复
    if (shouldRepeat) {
        localNotifi.repeatInterval =  type;
    }
    
    // 设置推送的声音
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    // 设置推送的区别符
    localNotifi.userInfo = @{@"name":name};
    // 按照前面设置的计划 执行此通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
}
+ (void)deleteLocalPushWithName:(NSString *)name{
    NSArray *allLocalNotifi = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    UILocalNotification *localNotifi  = nil;
    for (UILocalNotification *item in allLocalNotifi) {
        NSDictionary *userInfo = item.userInfo;
        if ([[userInfo objectForKey:@"name"] isEqualToString:name]) {
            localNotifi = item;
            break;
        }
    }
    if (localNotifi) {
        [[UIApplication sharedApplication] cancelLocalNotification:localNotifi];
    }
    
}
@end
