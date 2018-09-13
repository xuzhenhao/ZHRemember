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
/**标签缓存表名*/
#define kTagStoreTable @"TagStoreTableName"

@interface EvtEventStore()
@property (nonatomic, strong)   NSArray<EvtEventModel *>     *events;
/** 私有标签列表*/
@property (nonatomic, strong)   NSArray<EvtTagModel *>     *privateTags;
/** 公有标签列表*/
@property (nonatomic, strong)   NSArray<EvtTagModel *>     *publicTags;

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
    //生成事件id
    event.eventId = [NSString zh_onlyID];
    //先本地保存
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:event];
    [array addObjectsFromArray:self.events];
    self.events = [array copy];
    done(YES,nil);
    [self cacheLocalEvents:self.events];
    
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
- (void)deleteWithObjectId:(NSString *)objectId
                   eventId:(NSString *)eventId
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
    if (objectId) {
        [EvtEventApi deleteEventWithObjectId:objectId done:^(BOOL success, NSError *error) {
            if (error) {
                done(NO,error);
            }
        }];
    }
}
#pragma mark - tags
- (void)getEventTagsWithDone:(void(^)(BOOL succeed,NSError *error))done{
    //先加载本地的
    NSArray *localTags = [[ZHDBManager manager] objectsAtTable:kTagStoreTable];
    if (localTags.count > 0) {
        done(YES,nil);
        [self filterAndUpdateTags:localTags];
    }
    //拉取网络的
    __weak typeof(self)weakself = self;
    [EvtEventApi getTagListWithDone:^(NSArray<EvtTagModel *> *tagList, NSError *error) {
        if (error) {
            done(NO,error);
            return ;
        }
        done(YES,nil);
        [weakself filterAndUpdateTags:tagList];
        //缓存到本地
        [weakself cacheLocalTags:tagList];
    }];
}
- (void)saveTag:(EvtTagModel *)tag
           done:(void(^)(BOOL succeed,NSError *error))done{
    if (!tag) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地更新
    if (!tag.tagId) {
        //新增的
        tag.tagId = [NSString zh_onlyID];
        //先本地保存
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:tag];
        [array addObjectsFromArray:self.privateTags];
        self.privateTags = [array copy];
        done(YES,nil);
        NSMutableArray *tempM = [NSMutableArray arrayWithArray:self.privateTags];
        [tempM addObjectsFromArray:self.publicTags];
        [self cacheLocalTags:[tempM copy]];
    }else{
        //更新
        BOOL succeed = [[ZHDBManager manager] updateObject:tag forKey:tag.tagId atTable:kTagStoreTable];
        if (succeed) {
            //重新加载到内存
            NSArray *localTags = [[ZHDBManager manager] objectsAtTable:kTagStoreTable];
            [self filterAndUpdateTags:localTags];
            done(YES,nil);
        }
    }
    //同步网络
    __weak typeof(self)weakself = self;
    [EvtEventApi saveEventTag:tag done:^(BOOL success, NSError *error) {
        if (error) {
            done(NO,error);
        }else{
            [weakself loadDataWithPage:0 done:^(BOOL succeed, NSError *error) {
                
            }];
        }
    }];
}
- (void)deleteTagWithObjectId:(NSString *)objectId
                        tagId:(NSString *)tagId
                         done:(void(^)(BOOL succeed,NSError *error))done{
    if (!tagId) {
        done(NO,[NSError errorWithDomain:@"" code:-1 userInfo:@{NSErrorDescKey:@"数据为空"}]);
        return;
    }
    //先本地删除
    BOOL succeed = [[ZHDBManager manager] deleteObjectForKey:tagId atTable:kTagStoreTable];
    if (succeed) {
        //重新加载到内存
        NSArray *localTags = [[ZHDBManager manager] objectsAtTable:kTagStoreTable];
        done(YES,nil);
        [self filterAndUpdateTags:localTags];
    }
    if (objectId) {
        //同步网络
        [EvtEventApi deleteTagWithObjectId:objectId done:^(BOOL success, NSError *error) {
            if (error) {
                done(NO,error);
            }
        }];
    }
}
#pragma mark - helper
- (void)cacheLocalEvents:(NSArray<EvtEventModel *> *)eventLists{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ZHDBManager manager] deleteAllAtTable:kEventStoreTable];
        for (EvtEventModel *model in eventLists) {
            if (!model.eventId) {
                continue;
            }
            [[ZHDBManager manager] insertObject:model forKey:model.eventId atTable:kEventStoreTable];
        }
    });
}
//标签分类更新
- (void)filterAndUpdateTags:(NSArray<EvtTagModel *> *)tags{
    NSMutableArray *privateTags = [NSMutableArray array];
    NSMutableArray *publicTags = [NSMutableArray array];
    for (EvtTagModel *tag in tags) {
        if (tag.tagType == EventTagTypePublic) {
            [publicTags addObject:tag];
        }else{
            [privateTags addObject:tag];
        }
    }
    self.publicTags = [publicTags copy];
    self.privateTags = [privateTags copy];
}
- (void)cacheLocalTags:(NSArray<EvtTagModel *> *)tags{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[ZHDBManager manager] deleteAllAtTable:kTagStoreTable];
        for (EvtTagModel *model in tags) {
            if (!model.tagId) {
                continue;
            }
            [[ZHDBManager manager] insertObject:model forKey:model.tagId atTable:kTagStoreTable];
        }
    });
}

@end
