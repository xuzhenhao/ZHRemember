//
//  EvtEventApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventApi.h"
#import <AVOSCloud/AVOSCloud.h>
#import "AVObject+ApiExt.h"

/**事件表名*/
NSString *const EvtClassName = @"Event";
/**标签表名*/
NSString *const EvtTagClassName = @"Event_Tag";
/**每张表的ObjectId字段*/
NSString *const EvtObjectIdKey = @"objectId";
/**每张表的用户id字段*/
NSString *const EvtUserIdKey = @"user_id";

/**事件表-事件id字段*/
NSString *const EvtEventClassIdKey = @"event_id";
/**事件表-标签字段*/
NSString *const EvtEventClassTagKey = @"event_tag";
/**事件表-名字字段*/
NSString *const EvtEventClassNameKey = @"event_name";
/**事件表-开始时间字段*/
NSString *const EvtEventClassTimeKey = @"time_begin";
/**事件表-备注字段*/
NSString *const EvtEventClassRemarkKey = @"event_remark";
/**事件表-封面字段*/
NSString *const EvtEventClassCoverKey = @"event_cover";
/**事件表-重复周期字段*/
NSString *const EvtEventClassCycleKey = @"event_cycle";
/**事件表-推送提醒字段*/
NSString *const EvtEventClassPushKey = @"is_push";
/**事件表-置顶字段*/
NSString *const EvtEventClassTopKey = @"is_top";

/**标签表-标签id字段*/
NSString *const EvtTagClassIdKey = @"tag_id";
/**标签表-标签类型字段*/
NSString *const EvtTagClassTypeKey = @"tag_type";
/**标签表-标签名字段*/
NSString *const EvtTagClassNameKey = @"tag_name";


@implementation EvtEventApi
+ (void)saveEvent:(EvtEventModel *)event
             done:(void(^)(BOOL success, NSError *error))doneHandler{
    AVObject *eventObj = [[AVObject alloc] initWithClassName:EvtClassName];
    //关联标签表
    AVObject *tagObj = [AVObject objectWithClassName:EvtTagClassName objectId:event.tagModel.objectId];
    [eventObj setObject:tagObj forKey:EvtEventClassTagKey];
    
    [self fillObject:eventObj withEvent:event];
    [eventObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,error);
    }];
}
+ (void)getEventListsWithPage:(NSInteger)page
                         done:(void(^)(NSArray<EvtEventModel *> *eventLists, NSError *error))doneHandler{
    NSMutableArray *tempM = [NSMutableArray array];
    
    AVQuery *query = [AVQuery queryWithClassName:EvtClassName];
    //关联标签表的查询结果
    [query includeKey:EvtEventClassTagKey];
    //查询条件为用户id
    [query whereKey:EvtUserIdKey equalTo:[AVUser currentUser].objectId];
    //先查置顶的
    [query addDescendingOrder:EvtEventClassTopKey];
    [query addDescendingOrder:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj zh_localData];
            [dict setValue:obj.objectId forKey:EvtObjectIdKey];
            //取出嵌套的标签对象数据
            AVObject *tagObj = obj[EvtEventClassTagKey];
            NSDictionary *tagDict = [tagObj zh_localData];
            [tagDict setValue:tagObj.objectId forKey:EvtObjectIdKey];
            [dict setValue:tagDict forKey:EvtEventClassTagKey];
            
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[EvtEventModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,error);
    }];
}
+ (void)deleteEventWithObjectId:(NSString *)objectId
                           done:(void(^)(BOOL success,NSError *error))doneHandler{
    AVObject *eventObj = [AVObject objectWithClassName:EvtClassName objectId:objectId];
    [eventObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,error);
    }];
}

#pragma mark - tag
+ (void)saveEventTag:(EvtTagModel *)tagModel
                done:(void(^)(BOOL success,NSError *error))doneHandler{
    AVObject *tagObj = [[AVObject alloc] initWithClassName:EvtTagClassName];
    [self fillObject:tagObj withTag:tagModel];
    [tagObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,error);
    }];
}
+ (void)deleteTagWithObjectId:(NSString *)objectId
                         done:(void(^)(BOOL success,NSError *error))doneHandler{
    AVObject *tagObj = [AVObject objectWithClassName:EvtTagClassName objectId:objectId];
    [tagObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(succeeded,nil);
    }];
}
+ (void)getTagListWithDone:(void(^)(NSArray<EvtTagModel *> *tagList,NSError *error))doneHandler{
    NSMutableArray *tempM = [NSMutableArray array];
    //查询共有标签
    AVQuery *pubicQuery = [AVQuery queryWithClassName:EvtTagClassName];
    [pubicQuery whereKey:EvtTagClassTypeKey equalTo:@"0"];
    //查询私有标签
    AVQuery *privateQuery = [AVQuery queryWithClassName:EvtTagClassName];
    [privateQuery whereKey:EvtUserIdKey equalTo:[AVUser currentUser].objectId];
    //组合查询
    AVQuery *orQuery = [AVQuery orQueryWithSubqueries:@[pubicQuery,privateQuery]];
    
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj zh_localData];
            [dict setValue:obj.objectId forKey:EvtObjectIdKey];
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[EvtTagModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,nil);
    }];
}
+ (void)getPrivateTagListWithDone:(void(^)(NSArray<EvtTagModel *> *tagList,NSDictionary *result))doneHandler{
    NSMutableArray *tempM = [NSMutableArray array];
    
    AVQuery *privateQuery = [AVQuery queryWithClassName:EvtTagClassName];
    [privateQuery whereKey:EvtUserIdKey equalTo:[AVUser currentUser].objectId];
    
    [privateQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        for (AVObject *obj in objects) {
            NSDictionary *dict = [obj zh_localData];
            [dict setValue:obj.objectId forKey:EvtObjectIdKey];
            [tempM addObject:dict];
        }
        NSArray *lists = [MTLJSONAdapter modelsOfClass:[EvtTagModel class] fromJSONArray:tempM error:nil];
        doneHandler(lists,nil);
    }];
}

#pragma mark - utils
+ (void)fillObject:(AVObject *)tagObj withTag:(EvtTagModel *)tagModel{
    [tagObj setObject:[AVUser currentUser].objectId forKey:EvtUserIdKey];
    [tagObj setValue:tagModel.objectId forKey:EvtObjectIdKey];
    [tagObj setObject:tagModel.tagId forKey:EvtTagClassIdKey];
    [tagObj setObject:tagModel.tagName forKey:EvtTagClassNameKey];
    //标记为私有标签
    [tagObj setObject:@"1" forKey:EvtTagClassTypeKey];
}

+ (void)fillObject:(AVObject *)eventObj withEvent:(EvtEventModel *)eventModel{
    [eventObj setObject:[AVUser currentUser].objectId forKey:EvtUserIdKey];
    [eventObj setValue:eventModel.objectId forKey:EvtObjectIdKey];
    [eventObj setObject:eventModel.eventId forKey:EvtEventClassIdKey];
    [eventObj setObject:eventModel.eventName forKey:EvtEventClassNameKey];
    [eventObj setObject:eventModel.beginTime forKey:EvtEventClassTimeKey];
    [eventObj setObject:eventModel.remarks forKey:EvtEventClassRemarkKey];
    [eventObj setObject:eventModel.coverURLStr forKey:EvtEventClassCoverKey];
    [eventObj setObject:@(eventModel.cycleType) forKey:EvtEventClassCycleKey];
    [eventObj setObject:@(eventModel.isPush) forKey:EvtEventClassPushKey];
    [eventObj setObject:@(eventModel.isTop) forKey:EvtEventClassTopKey];
}


@end
