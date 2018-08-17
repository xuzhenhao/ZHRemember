//
//  EvtEditEventCycleViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventCycleViewModel.h"

@interface EvtEditEventCycleViewModel()

@property (nonatomic, assign)   EvtEventCycleType      cycleType;

@end

@implementation EvtEditEventCycleViewModel

+ (instancetype)viewModelWithCycleType:(EvtEventCycleType)type{
    EvtEditEventCycleViewModel *vm = [EvtEditEventCycleViewModel new];
    vm.cycleType = type;
    
    return vm;
}
- (void)updateCycleType:(EvtEventCycleType )type{
    self.cycleType = type;
}
+ (NSInteger)cycleTypeCount{
    return 5;
}
+ (NSString *)cycleTypeStringWithType:(EvtEventCycleType)type{
    NSArray *temp = [self cycleDesc];
    if (temp.count <= type) {
        return temp[0];
    }
    return temp[type];
}
#pragma mark - getter & setter
- (void)setCycleType:(EvtEventCycleType)cycleType{
    _cycleType = cycleType;
    self.cycleFormat = [EvtEditEventCycleViewModel cycleDesc][cycleType];
}
+ (NSArray *)cycleDesc{
    
    return @[@"不重复",
             @"每天",
             @"每周",
             @"每月",
             @"每年"];
}
@end
