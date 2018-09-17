//
//  ZHDiaryModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHDiaryModel.h"

@implementation ZHDiaryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"objectId":@"objectId",
             @"diaryId":@"diary_id",
             @"unixTime":@"create_time",
             @"diaryText":@"diary_text",
             @"diaryImageURL":@"diary_image",
             @"weatherImageName":@"weather_image",
             @"moodImageName":@"mood_image",
             @"wallPaperName":@"paper_image",
             @"fontName":@"font",
             @"fontSize":@"font_size",
             @"fontColor":@"font_color",
             };
}
+ (NSValueTransformer *)diaryIdJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)unixTimeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)diary_imageJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)diaryTextJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)wallPaperNameJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)weatherImageNameJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)moodImageNameJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)fontNameJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}
+ (NSValueTransformer *)fontSizeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.integerValue);
    }];
}
+ (NSValueTransformer *)fontColorJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}

@end
