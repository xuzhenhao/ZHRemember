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
+ (void)ResetPwdWithMobile:(NSString *)mobile
                  password:(NSString *)pwd
                      done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVQuery *userQuery = [AVQuery queryWithClassName:@"_User"];
    [userQuery whereKey:@"username" equalTo:mobile];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        AVUser *user = objects.firstObject;
        NSString *oldPwd = user[@"token"];
        //必须登录后才能修改
        [AVUser logInWithUsernameInBackground:mobile password:oldPwd block:^(AVUser * _Nullable user, NSError * _Nullable error) {
            
            [user updatePassword:oldPwd newPassword:pwd block:^(id  _Nullable object, NSError * _Nullable error) {
                if (error) {
                    doneHandler(NO,nil);
                }else{
                    doneHandler(YES,nil);
                    //额外保存密码，重置密码时使用
                    [user setObject:pwd forKey:@"token"];
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        //修改完后退出登录
                        [AVUser logOut];
                    }];
                }
                
            }];
        }];
        
        
    }];
}
@end
