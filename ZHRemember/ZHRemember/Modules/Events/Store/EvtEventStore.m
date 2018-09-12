//
//  EvtEventStore.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/11.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventStore.h"
#import "EvtEventApi.h"
#import "ZHDBManager.h"
/**事件缓存表名*/
#define kEventStoreTable @"EventStoreTableName"
/**事件列表缓存键名*/
#define kEventListStoreKey @"eventListStoreKeyName"

@interface EvtEventStore()
@property (nonatomic, strong)   NSArray<EvtEventModel *>     *events;

@end

@implementation EvtEventStore
+ (instancetype)shared{
    static EvtEventStore *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (void)loadDataWithPage:(NSInteger)page
                    done:(void(^)(BOOL succeed,NSError *error))done{
    //先加载本地的
    NSArray *localEvents = [[ZHDBManager manager] objectsAtTable:kEventStoreTable];
    if (localEvents.count > 0) {
        done(YES,nil);
        self.events = localEvents;
    }
    
    //加载网络的
    @weakify(self)
    [EvtEventApi getEventListsWithPage:0 done:^(NSArray<EvtEventModel *> *eventLists, NSError *error) {
        @strongify(self)
        if (error) {
            done(NO,error);
            return ;
        }
        done(YES,nil);
        self.events = eventLists;
        
        //异步缓存到本地
        [self cacheLocalEvents:eventLists];
    }];
}
- (void)addWithEvent:(EvtEventModel *)event
                done:(void(^)(BOOL succeed,NSError *error))done{
    if (!event) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地保存
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:event];
    [array addObjectsFromArray:self.events];
    self.events = [array copy];
    done(YES,nil);
//    [self cacheLocalEvents:self.events];//没有objectId
    
    //同步到远程
    [EvtEventApi saveEvent:event done:^(BOOL success, NSError *error) {
        if (error) {
            done(NO,error);
        }
    }];
}
- (void)updateWithEvent:(EvtEventModel *)event
                   done:(void(^)(BOOL succeed,NSError *error))done{
    if (!event) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地更新
    BOOL succeed = [[ZHDBManager manager] updateObject:event forKey:event.eventId atTable:kEventStoreTable];
    if (succeed) {
        //重新加载到内存
        NSArray *localEvents = [[ZHDBManager manager] objectsAtTable:kEventStoreTable];
        done(YES,nil);
        self.events = localEvents;
    }
    
    //同步到网络
    [EvtEventApi saveEvent:event done:^(BOOL success, NSError *error) {
        if (error) {
            done(NO,error);
        }
    }];
}
- (void)deleteWithEventId:(NSString *)eventId
                     done:(void(^)(BOOL succeed,NSError *error))done{
    if (!eventId) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地删除
    BOOL succeed = [[ZHDBManager manager] deleteObjectForKey:eventId atTable:kEventStoreTable];
    if (succeed) {
        //重新加载到内存
        NSArray *localEvents = [[ZHDBManager manager] objectsAtTable:kEventStoreTable];
        done(YES,nil);
        self.events = localEvents;
    }
    //同步到网络
    [EvtEventApi deleteWithEventId:eventId done:^(BOOL success, NSError *error) {
        if (error) {
            done(NO,error);
        }
    }];
}
#pragma mark - helper
- (void)cacheLocalEvents:(NSArray<EvtEventModel *> *)eventLists{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ZHDBManager manager] deleteAllAtTable:kEventStoreTable];
        for (EvtEventModel *model in eventLists) {
            [[ZHDBManager manager] insertObject:model forKey:model.eventId atTable:kEventStoreTable];
        }
    });
}
@end
