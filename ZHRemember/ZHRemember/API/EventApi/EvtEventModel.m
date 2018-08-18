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
             @"eventId":@"objectId",
             @"eventName":@"event_name",
             @"coverURLStr":@"event_cover",
             @"beginTime":@"time_begin",
             @"remarks":@"event_remark",
             @"cycleType":@"event_cycle",
             };
}
+ (NSValueTransformer *)cycleTypeJSONTransformer{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString * value, BOOL *success, NSError *__autoreleasing *error) {
        return @(value.integerValue);
    }];
}
@end
