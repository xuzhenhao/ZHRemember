//
//  ZHUserModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/6.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHUserModel.h"

/**用户扩展表名*/
NSString *const UserExtClassName = @"User_Ext";
/**用户id键名*/
NSString *const UserExtUserIdKey = @"user_id";
/**用户昵称键名*/
NSString *const UserExtNickNameKey = @"nick_name";
/**用户代币键名*/
NSString *const UserExtMoneyKey = @"money";
/**用户头像键名*/
NSString *const UserExtAvatarKey = @"avatar";
NSString *const UserExtSignKey = @"sign_time";
/**用户发表日记日期键名*/
NSString *const UserExtPublishKey = @"publish_time";
/**用户购买了去广告服务键名*/
NSString *const UserExtDisableAdsKey = @"ad_disable";
NSString *const UserExtCustomColorKey = @"color_enable";
NSString *const UserExtUnlockLetterKey = @"letter_unlock";

NSString *const UserExtUnlockFontCatKey = @"font_cat";
/**用户购买了华康少女体*/
NSString *const UserExtUnlockFontGirlKey = @"font_girl";
/**用户购买了字体简雅艺*/
NSString *const UserExtUnlockFontJYYKey = @"font_jyy";
/**用户购买了字体Sn*/
NSString *const UserExtUnlockFontSnKey = @"font_sn";
NSString *const UserExtUnlockFontColorKey = @"font_color_unlock";

@implementation ZHUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"objectId":@"objectId",
             @"userId":UserExtUserIdKey,
             @"nickName":UserExtNickNameKey,
             @"money":UserExtMoneyKey,
             @"avatarURL":UserExtAvatarKey,
             @"signTime":UserExtSignKey,
             @"publishTime":UserExtPublishKey,
             @"isDisableAd":UserExtDisableAdsKey,
             @"isEnableCustomColor":UserExtCustomColorKey,
             @"isUnlockLetter":UserExtUnlockLetterKey,
             @"isUnlockCatFont":UserExtUnlockFontCatKey,
             @"isUnlockGirlFont":UserExtUnlockFontGirlKey,
             @"isUnlockJYYFont":UserExtUnlockFontJYYKey,
             @"isUnlockSnFont":UserExtUnlockFontSnKey,
             @"isUnlockFontColor":UserExtUnlockFontColorKey,
             };
}
+ (NSValueTransformer *)objectIdJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)userIdJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)nickNameJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)moneyJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)avatarURLJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)signTimeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)publishTimeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)isDisableAdJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}
+ (NSValueTransformer *)isEnableCustomColorJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}
+ (NSValueTransformer *)isUnlockLetterJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}

+ (NSValueTransformer *)isUnlockCatFontJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}
+ (NSValueTransformer *)isUnlockGirlFontJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}
+ (NSValueTransformer *)isUnlockJYYFontJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}
+ (NSValueTransformer *)isUnlockSnFontJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}
+ (NSValueTransformer *)isUnlockFontColorJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isEqualToString:@"1"]) {
            return @(YES);
        }
        return @(NO);
    }];
}

@end
