//
//  ZHUserStore.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/12.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHUserModel.h"

/**
 账户数据层
 */
@interface ZHUserStore : NSObject

+ (instancetype)shared;

#pragma mark - 属性
/** 当前用户模型*/
@property (nonatomic, strong,readonly)   ZHUserModel     *currentUser;
/** 用户表objectId*/
@property (nonatomic, copy,readonly)     NSString    *userObjectId;
/** 账户余额*/
@property (nonatomic, copy,readonly)     NSString    *money;
/** 用户当日是否已签到*/
@property (nonatomic, assign,readonly)   BOOL      isSigned;
/** 用户当前是否已发表日记*/
@property (nonatomic, assign,readonly)   BOOL      isPublished;

#pragma mark - 方法
/**
 加载用户数据
 */
- (void)loadUser;

/**
 增加余额，传入负数，减少余额

 @param money 变化的数量
 */
- (void)addMoney:(NSInteger)money
            done:(void(^)(BOOL success,NSError *error))done;


/**
 更新用户当前已签到

 @param reward 签到奖励
 @param done 完成回调
 */
- (void)setUserHaveSignedWithReward:(NSInteger)reward
                               done:(void(^)(BOOL success,NSError *error))done;

/**
 更新用户今日已发表日记
 @param reward 奖励
 */
- (void)setUserHavePublishedWithReward:(NSInteger)reward
                                  done:(void(^)(BOOL success,NSError *error))done;

/**
 花费余额开启广告禁用

 @param cost 费用
 @param done 完成回调
 */
- (void)enableAdBlockWithCost:(NSInteger)cost
                         done:(void(^)(BOOL success,NSError *error))done;

/**
 花费余额开始自由主题色

 @param cost 费用
 @param done 完成回调
 */
- (void)enableCustomColorWithCost:(NSInteger)cost
                         done:(void(^)(BOOL success,NSError *error))done;

/**
 花费余额开启付费信纸

 @param cost 费用
 @param done 完成回调
 */
- (void)enableCustomLettersWithCost:(NSInteger)cost
                             done:(void(^)(BOOL success,NSError *error))done;

/**
 花费余额解锁自定义字体

 @param font 字体名称
 @param cost 费用
 @param done 完成回调
 */
- (void)enableCustomFont:(NSString *)font
                    cost:(NSInteger)cost
                    done:(void(^)(BOOL success,NSError *error))done;

/**
 花费余额解锁付费字体颜色

 @param cost 费用
 @param done 完成回调
 */
- (void)enableCustomFontColorWithCost:(NSInteger)cost
                    done:(void(^)(BOOL success,NSError *error))done;


/**
 清空用户信息，退出登录时调用
 */
- (void)clearUserInfo;

@end
