//
//  NSDate+ZHDate.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "NSDate+ZHDate.h"

@implementation NSDate (ZHDate)
- (NSString *)getWeekDay{
    NSArray *weekdays = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    return [weekdays objectAtIndex:(theComponents.weekday - 1)];
}
- (instancetype)getPriousorLaterDatewithMonth:(NSInteger)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:self options:0];
    return mDate;
    
}
@end
