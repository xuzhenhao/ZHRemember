//
//  EvtEventModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventModel.h"

@implementation EvtEventModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"objectId":@"objectId",
             @"eventId":@"event_id",
             @"eventName":@"event_name",
             @"coverURLStr":@"event_cover",
             @"beginTime":@"time_begin",
             @"remarks":@"event_remark",
             @"cycleType":@"event_cycle",
             @"tagModel": @"event_tag",
             };
}
+ (NSValueTransformer *)cycleTypeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.integerValue);
    }];
}
+ (NSValueTransformer *)tagModelJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            EvtTagModel *tag = [MTLJSONAdapter modelOfClass:[EvtTagModel class] fromJSONDictionary:value error:nil];
            return tag;
        }
        return nil;
    }];
}
@end
