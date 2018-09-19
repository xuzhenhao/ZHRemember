//
//  ZHAccountApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHUserModel.h"
#import "NSError+ZHLocailzed.h"

@interface ZHAccountApi : NSObject

/**
 注册用户

 @param account 用户名(手机号)
 @param pwd 密码
 @param doneHandler 完成回调
 */
+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)pwd
                       done:(void(^)(BOOL success,NSError *error))doneHandler;

/**
 登录

 @param account 用户名(手机号)
 @param pwd 密码
 @param doneHandler 完成回调
 */
+ (void)LoginWithAccount:(NSString *)account
                   password:(NSString *)pwd
                       done:(void(^)(BOOL success,NSError *error))doneHandler;

/**
 重置密码

 @param mobile 手机号
 @param pwd 新密码
 @param doneHandler 完成回调
 */
+ (void)ResetPwdWithMobile:(NSString *)mobile
                password:(NSString *)pwd
                    done:(void(^)(BOOL success,NSDictionary *result))doneHandler;

/**
 获取当前用户的用户信息
 */
+ (void)getUserInfoWithDoneHandler:(void(^)(ZHUserModel *user,NSError *error))doneHandler;

/**
 更新用户的签到时间

 @param objectId 用户扩展表对象id
 @param signTime 签到时间,mm-dd
 */
+ (void)updateUserSignTimeWithObjectId:(NSString *)objectId money:(NSString *)money
                              signTime:(NSString *)signTime done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 更新用户的发表日记奖励

 @param money 用户待更新的钱
 @param objectId 用户扩展表对象id
 @param publishTime 发表日记时间
 @param doneHandler 完成回调
 */
+ (void)updateUserPublishRewardWithObjectId:(NSString *)objectId
                                      money:(NSString *)money
                              publishTime:(NSString *)publishTime
                                           done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 更新用户的钱数

 @param money 钱数
 @param objectId 用户扩展表对象id
 @param doneHandler 完成回调
 */
+ (void)updateUserMoney:(NSString *)money
               objectId:(NSString *)objectId
                   done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 设置用户去广告

 @param objectId 用户扩展表对象id
 @param money 购买后待更新的钱数
 @param doneHandler 完成回调
 */
+ (void)updateUserDisalbeAdWithObjectId:(NSString *)objectId
                                  money:(NSString *)money
                            done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 解锁自定义主题色功能

 @param objectId 用户扩展表对象id
 @param money 购买后待更新的钱数
 @param doneHandler 完成回调
 */
+ (void)unlockCustomThemeWithObjectId:(NSString *)objectId
                                money:(NSString *)money
                                 done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 解锁付费信纸

 @param objectId 用户扩展表对象id
 @param money 购买后待更新的钱数
 @param doneHandler 完成回调
 */
+ (void)unlockLetterWithObjectId:(NSString *)objectId
                                money:(NSString *)money
                                 done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 解锁付费字体

 @param objectId 用户扩展id
 @param fontType 字体名
 @param money 购买后待更新的钱数
 @param doneHandler 完成回调
 */
+ (void)unlockFontWithObjectId:(NSString *)objectId
                      fontName:(ZHCustomFontType)fontType
                           money:(NSString *)money
                            done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

/**
 解锁付费字体颜色

 @param objectId 用户扩展id
 @param money 购买后待更新的钱数
 @param doneHandler 完成回调
 */
+ (void)unlockFontColorWithObjectId:(NSString *)objectId
                         money:(NSString *)money
                          done:(void(^)(BOOL isSuccess,NSError *error))doneHandler;

@end
