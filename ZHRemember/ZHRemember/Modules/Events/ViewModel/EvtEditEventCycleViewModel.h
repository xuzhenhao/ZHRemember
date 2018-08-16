//
//  EvtEditEventCycleViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EvtEventCycleNone = 0,//不重复
    EvtEventCycleDay,//每天
    EvtEventCycleWeek,//每周
    EvtEventCycleMonth,//每月
    EvtEventCycleYear,//每年
} EvtEventCycleType;

@interface EvtEditEventCycleViewModel : NSObject

/** 循环周期*/
@property (nonatomic, copy)     NSString    *cycleFormat;

+ (instancetype)viewModelWithCycleType:(EvtEventCycleType)type;

- (void)updateCycleType:(EvtEventCycleType )type;

/**周期可选数*/
+ (NSInteger)cycleTypeCount;
/**枚举类型对应的文字描述*/
+ (NSString *)cycleTypeStringWithType:(EvtEventCycleType)type;

@end
