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

@implementation ZHCache

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
