//
//  DIYPDFCalendarView.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 日历视图
 */
@interface DIYPDFCalendarView : UIView

+ (instancetype)calendarViewWithSize:(CGSize)size
                               month:(NSInteger)month
                                 day:(NSInteger)day;
@end
