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
/** 事件开始时间,倒数或周期事件为下一个周期时间，已发生且非周期的，为发生时间*/
@property (nonatomic, strong)   NSDate     *beginDate;

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

#pragma mark - public method
- (EvtEventModel *)getModelData{
    return [self.eventModel copy];
}

#pragma mark - private method
- (void)updateWithEventModel:(EvtEventModel *)model{
    self.eventModel = model;
    self.beginDate = [NSDate dateWithTimeIntervalSince1970:[model.beginTime integerValue]];
    
    self.coverURLStr = model.coverURLStr;
    self.eventName = model.eventName;
    self.remark = model.remarks;
    self.remindTime = [self calcuteRemindDays];
    self.weekTime = [self.beginDate getWeekDay];
    self.beginTime = [self.beginDate formattedDateWithFormat:@"yyyy.MM.dd" locale:[NSLocale systemLocale]];
}
#pragma mark - utils
- (BOOL)isFutureEvent{
    
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[self.eventModel.beginTime integerValue]];
    NSDate *currentDate = [NSDate date];
    
    return [eventDate isLaterThan:currentDate];
}
#pragma mark - date calcute
/**提醒时间.没有设置重复提醒则显示总天数，设置了重复提醒则显示距离下一个周期的天数*/
- (NSString *)calcuteRemindDays{
    //未发生的，倒数日
    if (self.isFutureEvent) {
        return [self calcuteFutrueEventDaysDesc];
    }
    
    //已发生的，纪念日
    EvtEventCycleType cycleType = self.eventModel.cycleType;
    if (cycleType == EvtEventCycleNone || cycleType == EvtEventCycleDay) {
        //不需要周期性提醒的，计算发生至今的总天数
        return [self getPassedDaysDesc];
    }else{
        //需要周期性提醒的，计算距离下一个周期的剩余天数
        return [self getLeftDaysDescWithCycleType:cycleType];
    }
}
/**未发生的事情，即倒数日*/
- (NSString *)calcuteFutrueEventDaysDesc{
    self.remindTypeTips = @"还剩";
    
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.eventModel.beginTime integerValue]];
    //抹掉时分秒的数据，统一从0点方便比较
    beginDate = [NSDate dateWithYear:beginDate.year month:beginDate.month day:beginDate.day];
    
    NSDate *currentDate = [NSDate date];
    currentDate = [NSDate dateWithYear:currentDate.year month:currentDate.month day:currentDate.day];
    
    NSInteger days = [beginDate daysLaterThan:currentDate];
    return [NSString stringWithFormat:@"%zd",days];
    
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
/**计算发生至今的总天数*/
- (NSString *)getPassedDaysDesc{
    NSInteger existDays = [self getExistDays];
    if (existDays > 0) {
        self.remindTypeTips = @"已经";
        return [NSString stringWithFormat:@"%zd",existDays];
    }else{
        self.remindTypeTips = @"就在";
        return @"今";
    }
}
/**需要周期性提醒的，计算距离下一个周期的剩余天数*/
- (NSString *)getLeftDaysDescWithCycleType:(EvtEventCycleType)type{
    NSInteger leftDays = 0;
    NSInteger existDays = [self getExistDays];
    NSDate *currentDate = [NSDate date];
    currentDate = [NSDate dateWithYear:currentDate.year month:currentDate.month day:currentDate.day];
    
    if (type == EvtEventCycleWeek) {
        //每过7天提醒
        NSInteger passedDays = existDays % 7;
        leftDays = 7 - passedDays;
    }else if (type == EvtEventCycleMonth){
        //每月提醒
        NSInteger passedMonth = existDays / 30;
        
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
        
        NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:[self.eventModel.beginTime integerValue]];
        beginDate = [NSDate dateWithYear:beginDate.year month:beginDate.month day:beginDate.day];
        
        NSDate *nextDate = [beginDate getPriousorLaterDatewithMonth:passedYears * 12];
        if ([nextDate isEarlierThan:currentDate]) {
            nextDate = [beginDate getPriousorLaterDatewithMonth:(passedYears+1) * 12];
        }
        leftDays = [nextDate daysLaterThan:currentDate];
    }

    self.beginDate = [currentDate dateByAddingDays:leftDays];
    if (leftDays > 0) {
        self.remindTypeTips = @"还剩";
        return [NSString stringWithFormat:@"%zd",leftDays];
    }else{
        self.remindTypeTips = @"就在";
        return @"今";
    }
}

@end
