//
//  ZHAccessManager.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHAccessManager.h"
#import <UserNotifications/UserNotifications.h>

@implementation ZHAccessManager

+ (void)getPushAccess:(void(^)(BOOL isAccess,NSString *message))done{
    NSString *msg = @"请到设置-记得-通知 中选择允许通知 来获取纪念日推送";
    
    UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        done(NO,msg);
    }else{
        done(YES,nil);
    }
}
@end
