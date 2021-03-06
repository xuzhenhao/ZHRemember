//
//  ZHCache.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHGlobalStore.h"
#import "ZHDBManager.h"
#import "ZHAccountApi.h"

static NSString *ZHThemeColorCacheKey = @"ZHThemeColorCacheKey";


@interface ZHGlobalStore()

@end

@implementation ZHGlobalStore

+ (instancetype)sharedInstance{
    static ZHGlobalStore *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)setProductEnvironmentEnable:(BOOL)isEnable{
    [[NSUserDefaults standardUserDefaults] setBool:isEnable forKey:@"environment"];
    [[NSUserDefaults standardUserDefaults] synchronize];;
}
+ (BOOL)isProductEnvironment{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"environment"];
}
#pragma mark - Gesture password
+ (BOOL)isGestureExist{
    NSString *pwd = [self gesturePassword];
    return pwd.length > 0 ;
}
+ (void)saveGesturePassword:(NSString *)pwd{
    pwd = pwd ?: @"";
    //手势密码和用户id绑定
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:[NSString stringWithFormat:@"ZHGesturePwd%@",[ZHUserStore shared].currentUser.userId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)gesturePassword{
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ZHGesturePwd%@",[ZHUserStore shared].currentUser.userId]];
    return pwd;
}
#pragma mark - theme color
+ (void)cacheThemeColor:(UIColor *)themeColor{
    if (!themeColor) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:themeColor];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:ZHThemeColorCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIColor *)getThemeColor{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ZHThemeColorCacheKey];
    UIColor *color = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return color;
}
#pragma mark - push
+ (NSInteger)getEventPushHour{
    return 8;
}
+ (NSInteger)getEventPushMinute{
    return 30;
}

+ (NSInteger)getDiaryPushHour{
    return 21;
}
+ (NSInteger)getDiaryPushMinute{
    return 30;
}
@end
