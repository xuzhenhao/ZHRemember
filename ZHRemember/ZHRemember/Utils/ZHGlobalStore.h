//
//  ZHCache.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 提供全局共享的数据，对外屏蔽存储的具体实现(NSUserDefaults,FMDB等)
 */
@interface ZHGlobalStore : NSObject

+ (instancetype)sharedInstance;

/**
 配置是否为生产环境

 @param isEnable 是否为生产环境
 */
+ (void)setProductEnvironmentEnable:(BOOL)isEnable;
+ (BOOL)isProductEnvironment;

#pragma mark - theme color
/**
 缓存用户选择的主题色

 @param themeColor 主题色
 */
+ (void)cacheThemeColor:(UIColor *)themeColor;

/**
 获取用户的主题色
 */
+ (UIColor *)getThemeColor;

#pragma mark - push
/**事件当天推送，小时设置*/
+ (NSInteger)getEventPushHour;
/**事件当天推送，分钟设置*/
+ (NSInteger)getEventPushMinute;

+ (NSInteger)getDiaryPushHour;
+ (NSInteger)getDiaryPushMinute;

@end
