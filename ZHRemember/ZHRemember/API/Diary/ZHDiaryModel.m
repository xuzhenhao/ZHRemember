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
             @"diaryId":@"objectId",
             @"unixTime":@"create_time",
             @"diaryText":@"diary_text",
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
+ (NSValueTransformer *)diaryTextJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%@",value];
    }];
}

@end
