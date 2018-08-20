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
NSString *const EvtTagClassName = @"Event_Tag";

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

#pragma mark - tag
+ (void)saveEventTag:(EvtTagModel *)tagModel
                done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVObject *tagObj = [[AVObject alloc] initWithClassName:EvtTagClassName];
    [self fillObject:tagObj withTag:tagModel];
    [tagObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}
+ (void)deleteEventTag:(NSString *)tagId
                  done:(void(^)(BOOL success,NSDictionary *result))doneHandler{
    AVObject *tagObj = [AVObject objectWithClassName:EvtTagClassName objectId:tagId];
    [tagObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}
+ (void)getTagListWithDone:(void(^)(NSArray<EvtTagModel *> *tagList,NSDictionary *result))doneHandler{
    NSMutableArray *tempM = [NSMutableArray array];
    
    AVQuery *pubicQuery = [AVQuery queryWithClassName:EvtTagClassName];
    [pubicQuery whereKey:@"tag_type" equalTo:@"0"];
    
    AVQuery *privateQuery = [AVQuery queryWithClassName:EvtTagClassName];
    [privateQuery whereKey:@"user_id" equalTo:[AVUser currentUser].objectId];
    
    AVQuery *orQuery = [AVQuery orQueryWithSubqueries:@[pubicQuery,privateQuery]];
    
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj valueForKey:@"localData"];
            [dict setValue:obj.objectId forKey:@"objectId"];
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[EvtTagModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,nil);
    }];
}
+ (void)getPrivateTagListWithDone:(void(^)(NSArray<EvtTagModel *> *tagList,NSDictionary *result))doneHandler{
    NSMutableArray *tempM = [NSMutableArray array];
    
    AVQuery *privateQuery = [AVQuery queryWithClassName:EvtTagClassName];
    [privateQuery whereKey:@"user_id" equalTo:[AVUser currentUser].objectId];
    
    [privateQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj valueForKey:@"localData"];
            [dict setValue:obj.objectId forKey:@"objectId"];
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[EvtTagModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,nil);
    }];
}

#pragma mark - utils
+ (void)fillObject:(AVObject *)tagObj withTag:(EvtTagModel *)tagModel{
    [tagObj setObject:[AVUser currentUser].objectId forKey:@"user_id"];
    [tagObj setValue:tagModel.tagId forKey:@"objectId"];
    [tagObj setObject:tagModel.tagName forKey:@"tag_name"];
    [tagObj setObject:@"1" forKey:@"tag_type"];
}

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
