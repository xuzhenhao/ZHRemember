//
//  EvtEditEventDateViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventDateViewModel.h"

@implementation EvtEditEventDateViewModel

+ (instancetype)viewModelWithDate:(NSString *)dateString{
    EvtEditEventDateViewModel *vm = [EvtEditEventDateViewModel new];
    
    vm.unixTime = dateString;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateString.integerValue];
    vm.dateFormat = [date formattedDateWithFormat:@"yyyy年MM月dd日HH时" locale:[NSLocale systemLocale]];
    
    return vm;
}

- (void)setDateComp:(NSDateComponents *)dateComp{
    self.dateFormat = [NSString stringWithFormat:@"%zd年%zd月%zd日%zd时",dateComp.year,dateComp.month,dateComp.day,dateComp.hour];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:dateComp];
    self.unixTime = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
}
@end
