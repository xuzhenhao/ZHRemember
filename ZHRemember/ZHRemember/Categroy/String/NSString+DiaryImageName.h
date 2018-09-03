//
//  NSString+DiaryImageName.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/3.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 日记图片名称
 */
@interface NSString (DiaryImageName)

/**
 获取指定索引的天气图片名称

 @param index 索引
 */
+ (NSString *)diary_weatherImageNameOfIndex:(NSInteger)index;

/**
 获取指定索引的心情图片名称

 @param index 索引
 */
+ (NSString *)diary_moodImageNameOfIndex:(NSInteger)index;

@end
