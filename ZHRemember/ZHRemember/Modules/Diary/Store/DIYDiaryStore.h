//
//  DIYDiaryStore.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHDiaryModel.h"

/**
 日记模块数据层
 */
@interface DIYDiaryStore : NSObject

@property (nonatomic, strong,readonly)   NSArray<ZHDiaryModel *>     *diarys;

+ (instancetype)shared;

/**
 加载数据
 
 @param page 索引
 @param done 完成回调
 */
- (void)loadDataWithPage:(NSInteger)page
                    done:(void(^)(BOOL succeed,NSError *error))done;
- (void)saveDiary:(ZHDiaryModel *)diary
           done:(void(^)(BOOL succeed,NSError *error))done;
/**
 删除日记
 
 @param objectId 主键id
 @param diaryId 日记id
 @param done 完成回调
 */
- (void)deleteDiaryWithObjectId:(NSString *)objectId
                        diaryId:(NSString *)diaryId
                         done:(void(^)(BOOL succeed,NSError *error))done;

@end
