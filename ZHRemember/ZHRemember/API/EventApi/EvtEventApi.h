//
//  EvtEventApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtEventModel.h"
#import "EvtTagModel.h"

@interface EvtEventApi : NSObject

+ (void)saveEvent:(EvtEventModel *)event
             done:(void(^)(BOOL success,NSDictionary *result))doneHandler;
+ (void)getEventListsWithPage:(NSInteger)page
                         done:(void(^)(NSArray<EvtEventModel *> *eventLists,NSDictionary *result))doneHandler;
#pragma mark - tag
/**
 保存（新增/修改）标签

 @param tagModel 标签
 @param doneHandler 完成回调
 */
+ (void)saveEventTag:(EvtTagModel *)tagModel
                       done:(void(^)(BOOL success,NSDictionary *result))doneHandler;

/**
 删除标签

 @param tagId 标签id
 @param doneHandler 完成回调
 */
+ (void)deleteEventTag:(NSString *)tagId
                  done:(void(^)(BOOL success,NSDictionary *result))doneHandler;

/**
 获取所有标签列表(包括私人+共有)

 @param doneHandler 完成回调
 */
+ (void)getTagListWithDone:(void(^)(NSArray<EvtTagModel *> *tagList,NSDictionary *result))doneHandler;

+ (void)getPrivateTagListWithDone:(void(^)(NSArray<EvtTagModel *> *tagList,NSDictionary *result))doneHandler;

@end
