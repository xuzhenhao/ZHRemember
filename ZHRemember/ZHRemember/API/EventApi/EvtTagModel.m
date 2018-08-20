//
//  EvtTagModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtTagModel.h"

@implementation EvtTagModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"tagId":@"objectId",
             @"tagName":@"tag_name",
             @"tagType":@"tag_type",
             };
}
+ (NSValueTransformer *)tagTypeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.integerValue);
    }];
}

@end
