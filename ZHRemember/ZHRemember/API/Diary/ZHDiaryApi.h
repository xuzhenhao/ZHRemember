//
//  ZHDiaryApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHDiaryModel.h"

@interface ZHDiaryApi : NSObject

/**
 保存日记

 @param diary 日记模型
 @param doneHandler 完成回调
 */
+ (void)saveDiary:(ZHDiaryModel *)diary
             done:(void(^)(BOOL success,NSDictionary *result))doneHandler;

/**
 获取日记列表

 @param page 分页查询，当前页数(每页100条记录)
 @param doneHandler 完成回调
 */
+ (void)getDiaryListWithPage:(NSInteger)page
                        done:(void(^)(NSArray<ZHDiaryModel *> *diaryList,NSDictionary *result))doneHandler;

@end