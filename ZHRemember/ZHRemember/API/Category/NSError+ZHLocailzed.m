//
//  NSError+ZHLocailzed.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/17.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "NSError+ZHLocailzed.h"

NSString *zh_SMSErrorCode = @"300468";//短信验证码错误
NSString *zh_SMSExceedCode = @"300478";//当天验证码次数已超
NSString *zh_AccountExistCode = @"214";//账户已存在错误
NSString *zh_PwdErrorCode = @"210";//密码错误
NSString *zh_AccountNotExistCode = @"211";//账户不存在

@implementation NSError (ZHLocailzed)

- (NSError *)zh_localized{
    NSString *code = self.userInfo[@"code"] ?: [NSString stringWithFormat:@"%ld",self.code];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.userInfo];
    
    if ([code isEqualToString:zh_SMSErrorCode]) {
        [dict setObject:@"短信验证码错误" forKey:NSErrorDescKey];
    }else if([code isEqualToString:zh_SMSExceedCode]){
        [dict setObject:@"验证码次数已超，请明天再试" forKey:NSErrorDescKey];
    }
    else if([code isEqualToString:zh_AccountExistCode]){
        [dict setObject:@"账户已存在" forKey:NSErrorDescKey];
    }else if([code isEqualToString:zh_PwdErrorCode]){
        [dict setObject:@"账号或密码不正确" forKey:NSErrorDescKey];
    }else if([code isEqualToString:zh_AccountNotExistCode]){
        [dict setObject:@"账户不存在" forKey:NSErrorDescKey];
    }

    [self setValue:[dict copy] forKey:@"userInfo"];
    return self;
}
@end
