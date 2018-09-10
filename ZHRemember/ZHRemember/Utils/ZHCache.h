//
//  ZHCache.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHUserModel.h"

/**
 缓存业务数据，对外屏蔽存储是具体实现(NSUserDefaults,FMDB等)
 */
@interface ZHCache : NSObject

+ (instancetype)sharedInstance;

/**
 配置是否为生产环境

 @param isEnable 是否为生产环境
 */
+ (void)setProductEnvironmentEnable:(BOOL)isEnable;
+ (BOOL)isProductEnvironment;
#pragma mark - user
/** 缓存的当前用户模型*/
@property (nonatomic, strong,readonly)   ZHUserModel     *currentUser;
/** 缓存当前用的钱*/
@property (nonatomic, copy,readonly)     NSString    *money;
/** 当日是否已签到*/
@property (nonatomic, assign,readonly)   BOOL      isSigned;
/** 当前是否已发表日记*/
@property (nonatomic, assign,readonly)   BOOL      isPublished;

- (void)updateUser:(ZHUserModel *)user;
- (void)updateUserMoney:(NSString *)money;
- (void)setUserUnlockLetter;
/**设置用户已签到*/
- (void)setUserSigned;
/**当前用户是否已解锁付费信纸*/
- (BOOL)isUnlockLetter;

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

@end
