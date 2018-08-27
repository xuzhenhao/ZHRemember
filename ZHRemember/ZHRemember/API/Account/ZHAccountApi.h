//
//  ZHAccountApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHAccountApi : NSObject

/**
 注册用户

 @param account 用户名(手机号)
 @param pwd 密码
 @param doneHandler 完成回调
 */
+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)pwd
                       done:(void(^)(BOOL success,NSDictionary *result))doneHandler;

/**
 登录

 @param account 用户名(手机号)
 @param pwd 密码
 @param doneHandler 完成回调
 */
+ (void)LoginWithAccount:(NSString *)account
                   password:(NSString *)pwd
                       done:(void(^)(BOOL success,NSDictionary *result))doneHandler;

@end
