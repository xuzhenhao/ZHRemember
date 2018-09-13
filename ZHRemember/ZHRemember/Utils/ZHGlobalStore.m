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
@property (nonatomic, strong)   ZHUserModel     *currentUser;
@property (nonatomic, copy)     NSString    *money;
@property (nonatomic, assign)   BOOL      isSigned;
@property (nonatomic, assign)   BOOL      isPublished;

@end

@implementation ZHGlobalStore

+ (instancetype)sharedInstance{
    static ZHGlobalStore *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.isSigned = NO;
        manager.isPublished = NO;
        manager.money = @"0";
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
#pragma mark - user


- (void)updateUserMoney:(NSString *)money{
    self.money = money;
    self.currentUser.money = money;
}
- (void)setUserUnlockLetter{
    self.currentUser.isUnlockLetter = YES;
}
- (void)setUserSigned{
    self.isSigned = YES;
}
- (void)setUserPublished{
    self.isPublished = YES;
}
- (void)_checkIfSigned{
    NSString *now = [[NSDate date] formattedDateWithFormat:@"MM-dd" locale:[NSLocale systemLocale]];
    if ([self.currentUser.signTime isEqualToString:now]) {
        self.isSigned = YES;
    }
    if ([self.currentUser.publishTime isEqualToString:now]) {
        self.isPublished = YES;
    }
}
- (BOOL)isUnlockLetter{
    return self.currentUser.isUnlockLetter;
}
- (NSString *)userObjectId{
    return self.currentUser.objectId;
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
@end
