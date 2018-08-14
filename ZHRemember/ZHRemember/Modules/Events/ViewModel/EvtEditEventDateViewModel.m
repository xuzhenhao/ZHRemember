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
    
    return vm;
}

- (void)setDateComp:(NSDateComponents *)dateComp{
    self.dateFormat = [NSString stringWithFormat:@"%zd年%zd月%zd日%zd时",dateComp.year,dateComp.month,dateComp.day,dateComp.hour];
}
@end
