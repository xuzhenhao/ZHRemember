//
//  ZHAccountApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHAccountApi.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation ZHAccountApi

+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)pwd
                       done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVUser *user = [AVUser user];
    user.username = account;
    user.password = pwd;
    user.mobilePhoneNumber = account;
    [user setObject:pwd forKey:@"token"];//重置密码时使用
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}
+ (void)LoginWithAccount:(NSString *)account
                password:(NSString *)pwd
                    done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    [AVUser logInWithUsernameInBackground:account password:pwd block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        BOOL succeed = error ? NO : YES;
        doneHandler(succeed,nil);
    }];
}

@end
