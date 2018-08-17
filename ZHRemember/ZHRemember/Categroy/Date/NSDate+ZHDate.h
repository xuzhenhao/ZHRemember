//
//  NSDate+ZHDate.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZHDate)

/**
 查询当前时间为星期几

 @return 星期几
 */
- (NSString *)getWeekDay;

/**
 获取给定时间前后n个月后的时间

 @param month 正数表示往后，负数表示往前
 @return n个月后的时间
 */
- (instancetype)getPriousorLaterDatewithMonth:(NSInteger)month;

@end
