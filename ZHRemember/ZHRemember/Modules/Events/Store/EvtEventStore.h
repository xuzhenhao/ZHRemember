//
//  EvtEventStore.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/11.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtEventModel.h"

/**
 数据层，对外提供和存储Event数据
 */
@interface EvtEventStore : NSObject

+ (instancetype)shared;

/** 事件列表,供外部观察*/
@property (nonatomic, strong,readonly)   NSArray<EvtEventModel *>     *events;
/** 私有标签列表*/
@property (nonatomic, strong,readonly)   NSArray<EvtTagModel *>     *privateTags;
/** 公有标签列表*/
@property (nonatomic, strong,readonly)   NSArray<EvtTagModel *>     *publicTags;

#pragma mark - events
/**
 加载数据

 @param page 索引
 @param done 完成回调
 */
- (void)loadDataWithPage:(NSInteger)page
                    done:(void(^)(BOOL succeed,NSError *error))done;

/**
 新增事件

 @param event 事件模型
 @param done 完成回调
 */
- (void)addWithEvent:(EvtEventModel *)event
                done:(void(^)(BOOL succeed,NSError *error))done;

/**
 更新事件

 @param event 事件模型
 @param done 完成回调
 */
- (void)updateWithEvent:(EvtEventModel *)event
                   done:(void(^)(BOOL succeed,NSError *error))done;

/**
 删除事件

 @param objectId 表id
 @param eventId 事件id
 @param done 完成回调
 */
- (void)deleteWithObjectId:(NSString *)objectId
                   eventId:(NSString *)eventId
                   done:(void(^)(BOOL succeed,NSError *error))done;

#pragma mark - tags

/**
 获取事件标签

 @param done 完成回调
 */
- (void)getEventTagsWithDone:(void(^)(BOOL succeed,NSError *error))done;

/**
 保存/更新 标签

 @param tag 标签实体
 @param done 完成回调
 */
- (void)saveTag:(EvtTagModel *)tag
           done:(void(^)(BOOL succeed,NSError *error))done;

/**
 删除标签

 @param objectId 主键id
 @param tagId 标签id
 @param done 完成回调
 */
- (void)deleteTagWithObjectId:(NSString *)objectId
                        tagId:(NSString *)tagId
                         done:(void(^)(BOOL succeed,NSError *error))done;

@end
