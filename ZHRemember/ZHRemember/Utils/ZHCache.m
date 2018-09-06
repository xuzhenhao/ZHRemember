//
//  ZHCache.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHCache.h"
#import "ZHDBManager.h"

static NSString *ZHThemeColorCacheKey = @"ZHThemeColorCacheKey";


@interface ZHCache()
@property (nonatomic, strong)   ZHUserModel     *currentUser;
@property (nonatomic, assign)   BOOL      isSigned;
@property (nonatomic, assign)   BOOL      isPublished;

@end

@implementation ZHCache

+ (instancetype)sharedInstance{
    static ZHCache *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.isSigned = NO;
        manager.isPublished = NO;
    });
    return manager;
}
#pragma mark - user
- (void)updateUser:(ZHUserModel *)user{
    self.currentUser = user;
    if (!self.isSigned || !self.isPublished) {
        [self _checkIfSigned];
    }
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
