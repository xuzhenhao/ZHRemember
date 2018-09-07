//
//  ZHAccountApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHAccountApi.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+ApiExt.h"

@implementation ZHAccountApi

+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)pwd
                       done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVUser *user = [AVUser user];
    user.username = account;
    user.password = pwd;
    user.mobilePhoneNumber = account;
    [user setObject:pwd forKey:@"token"];//重置密码时使用
    
    __weak typeof(self)weakself = self;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
        if (succeeded) {
            [weakself _updateUserExtsTableWithUserId:user.objectId userName:user.username];
        }
    }];
}

/**
 更新用户扩展表

 @param userId 用户id
 */
+ (void)_updateUserExtsTableWithUserId:(NSString *)userId userName:(NSString *)userName{
    AVObject *userExt = [AVObject objectWithClassName:UserExtClassName];
    [userExt setObject:userId forKey:UserExtUserIdKey];
    //昵称默认为手机号，可修改
    [userExt setObject:userName forKey:UserExtNickNameKey];
    //代币，默认0
    [userExt setObject:@"0" forKey:UserExtMoneyKey];
    [userExt setObject:@"" forKey:UserExtAvatarKey];
    
    [userExt saveInBackground];
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
+ (void)getUserInfoWithDoneHandler:(void(^)(ZHUserModel *user,NSError *error))doneHandler{
    AVQuery *query = [AVQuery queryWithClassName:UserExtClassName];
    [query whereKey:UserExtUserIdKey equalTo:[AVUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        AVObject *obj  =  objects.lastObject;
        NSDictionary *dict = [obj zh_localData];
        [dict setValue:obj.objectId forKey:AVObjectIdKey];
        
        ZHUserModel *user = [MTLJSONAdapter modelOfClass:[ZHUserModel class] fromJSONDictionary:dict error:&error];
        doneHandler(user,error);
    }];
}
+ (void)updateUserSignTimeWithObjectId:(NSString *)objectId
                              signTime:(NSString *)signTime done:(void (^)(BOOL isSuccess, NSError *error))doneHandler{
    if (!objectId || !signTime) {
        doneHandler(NO,nil);
    }
    AVObject *userObj = [AVObject objectWithClassName:UserExtClassName objectId:objectId];
    [userObj setObject:signTime forKey:UserExtSignKey];
    [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,error);
    }];
}
+ (void)updateUserMoney:(NSString *)money
               objectId:(NSString *)objectId
                   done:(void(^)(BOOL isSuccess,NSError *error))doneHandler{
    if (!objectId || !money) {
        doneHandler(NO,nil);
    }
    AVObject *userObj = [AVObject objectWithClassName:UserExtClassName objectId:objectId];
    [userObj setObject:money forKey:UserExtMoneyKey];
    [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,error);
    }];
}
@end
