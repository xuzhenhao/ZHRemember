//
//  EvtEventApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventApi.h"
#import <AVOSCloud/AVOSCloud.h>

NSString *const EvtClassName = @"Event";

@implementation EvtEventApi
+ (void)saveEvent:(EvtEventModel *)event
             done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVObject *eventObj = [[AVObject alloc] initWithClassName:EvtClassName];
    [self fillObject:eventObj withEvent:event];
    [eventObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}

#pragma mark - utils
+ (void)fillObject:(AVObject *)eventObj withEvent:(EvtEventModel *)eventModel{
    
    [eventObj setValue:eventModel.eventId forKey:@"objectId"];
    [eventObj setObject:eventModel.eventName forKey:@"event_name"];
    [eventObj setObject:eventModel.beginTime forKey:@"time_begin"];
    [eventObj setObject:eventModel.remarks forKey:@"event_remark"];
    
    AVFile *coverFile = [AVFile fileWithData:eventModel.coverData];
    [eventObj setObject:coverFile forKey:@"event_cover"];
}


@end
