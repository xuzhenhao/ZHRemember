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
+ (void)getEventListsWithPage:(NSInteger)page
                         done:(void(^)(NSArray<EvtEventModel *> *eventLists,NSDictionary *result))doneHandler{
    NSMutableArray *tempM = [NSMutableArray array];
    
    AVQuery *query = [AVQuery queryWithClassName:EvtClassName];
    
    [query whereKey:@"user_id" equalTo:[AVUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj valueForKey:@"localData"];
            [dict setValue:obj.objectId forKey:@"objectId"];
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[EvtEventModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,nil);
    }];
}

#pragma mark - utils
+ (void)fillObject:(AVObject *)eventObj withEvent:(EvtEventModel *)eventModel{
    [eventObj setObject:[AVUser currentUser].objectId forKey:@"user_id"];
    [eventObj setValue:eventModel.eventId forKey:@"objectId"];
    [eventObj setObject:eventModel.eventName forKey:@"event_name"];
    [eventObj setObject:eventModel.beginTime forKey:@"time_begin"];
    [eventObj setObject:eventModel.remarks forKey:@"event_remark"];
    [eventObj setObject:eventModel.coverURLStr forKey:@"event_cover"];
    [eventObj setObject:@(eventModel.cycleType) forKey:@"event_cycle"];
}


@end
