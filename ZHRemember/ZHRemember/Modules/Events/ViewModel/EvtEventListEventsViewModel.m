//
//  EvtEventListEventsViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListEventsViewModel.h"


@interface EvtEventListEventsViewModel()

@property (nonatomic, strong)   EvtEventModel     *eventModel;

@end

@implementation EvtEventListEventsViewModel

#pragma mark - init
+ (instancetype)viewModelWithModel:(EvtEventModel *)model{
    EvtEventListEventsViewModel *vm = [EvtEventListEventsViewModel new];
    [vm updateWithEventModel:model];
    
    return vm;
}
+ (NSArray<EvtEventListEventsViewModel *> *)viewModelsWithModels:(NSArray<EvtEventModel *> *)models{
    NSMutableArray *tempM = [NSMutableArray array];
    
    for (EvtEventModel *model in models) {
        EvtEventListEventsViewModel *vm = [self viewModelWithModel:model];
        [tempM addObject:vm];
    }
    
    return [tempM copy];
}

#pragma mark - private method
- (EvtEventModel *)getModelData{
    return [self.eventModel copy];
}

#pragma mark - private method
- (void)updateWithEventModel:(EvtEventModel *)model{
    self.eventModel = model;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.beginTime integerValue]];
    
    self.coverURLStr = model.coverURLStr;
    self.eventName = model.eventName;
    self.remark = model.remarks;
    self.remindTime = [self calcuteRemindDays];
    self.weekTime = [date getWeekDay];
    self.beginTime = [date formattedDateWithFormat:@"yyyy.MM.dd" locale:[NSLocale systemLocale]];
}
/**提醒时间.没有设置重复提醒则显示总天数，设置了重复提醒则显示距离下一个周期的天数*/
- (NSString *)calcuteRemindDays{
    
    EvtEventCycleType cycleType = self.eventModel.cycleType;
    if (cycleType == EvtEventCycleNone || cycleType == EvtEventCycleDay) {
        NSInteger existDays = [self getExistDays];
        if (existDays > 0) {
            return [NSString stringWithFormat:@"%zd",existDays];
        }else{
            return @"今";
        }
    }else{
        return [self getLeftDaysDescWithCycleType:cycleType];
    }
    
}
/**计算事件开始到今天为止，已经经过的天数*/
- (NSInteger)getExistDays{
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.eventModel.beginTime integerValue]];
    //抹掉时分秒的数据，统一从0点方便比较
    beginDate = [NSDate dateWithYear:beginDate.year month:beginDate.month day:beginDate.day];
    NSDate *currentDate = [NSDate date];
    NSInteger existDays = [currentDate daysLaterThan:beginDate];
    
    return existDays;
}
/**需要周期性提醒的，计算距离下一个周期的剩余天数*/
- (NSString *)getLeftDaysDescWithCycleType:(EvtEventCycleType)type{
    NSInteger leftDays = 0;
    NSInteger existDays = [self getExistDays];
    if (type == EvtEventCycleWeek) {
        //每过7天提醒
        NSInteger passedDays = existDays % 7;
        leftDays = 7 - passedDays;
    }else if (type == EvtEventCycleMonth){
        //每月提醒
        NSInteger passedMonth = existDays / 30;
        
        NSDate *currentDate = [NSDate date];
        currentDate = [NSDate dateWithYear:currentDate.year month:currentDate.month day:currentDate.day];
        
        NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.eventModel.beginTime integerValue]];
        beginDate = [NSDate dateWithYear:beginDate.year month:beginDate.month day:beginDate.day];
        
        NSDate *nextDate = [beginDate getPriousorLaterDatewithMonth:passedMonth];
        if ([nextDate isEarlierThan:currentDate]) {
            nextDate = [beginDate getPriousorLaterDatewithMonth:passedMonth+1];
        }
        leftDays = [nextDate daysLaterThan:currentDate];
        
    }else if (type == EvtEventCycleYear){
        //每年的今天提醒
        NSInteger passedYears = existDays / 360;
        
        NSDate *currentDate = [NSDate date];
        currentDate = [NSDate dateWithYear:currentDate.year month:currentDate.month day:currentDate.day];
        
        NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.eventModel.beginTime integerValue]];
        beginDate = [NSDate dateWithYear:beginDate.year month:beginDate.month day:beginDate.day];
        
        NSDate *nextDate = [beginDate getPriousorLaterDatewithMonth:passedYears * 12];
        if ([nextDate isEarlierThan:currentDate]) {
            nextDate = [beginDate getPriousorLaterDatewithMonth:(passedYears+1) * 12];
        }
        leftDays = [nextDate daysLaterThan:currentDate];
    }

    if (leftDays > 0) {
        return [NSString stringWithFormat:@"%zd",existDays];
    }else{
        return @"天";
    }
}

@end
