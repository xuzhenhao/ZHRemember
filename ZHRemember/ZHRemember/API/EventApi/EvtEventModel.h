//
//  EvtEventModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EvtEventCycleTypeNone = 0,//不重复
    EvtEventCycleTypeYear,//每年
    EvtEventCycleTypeMonth,//每月
    EvtEventCycleTypeWeek,//每周
    EvtEventCycleTypeDay,//每日
    EvtEventCycleTypeCustom,//自定义
} EvtEventCycleType;//重复周期

@interface EvtEventModel : NSObject

/** 事件id*/
@property (nonatomic, copy)     NSString    *eventId;
/** 事件名*/
@property (nonatomic, copy)     NSString    *eventName;
/** 事件标签*/
@property (nonatomic, copy)     NSString    *eventLabel;

/** 事件类型，根据时间即可判断。未来的时间即为倒数，过去的时间即为纪念日*/
/** 封面地址*/
@property (nonatomic, copy)     NSString    *coverURLStr;
/** 开始时间*/
@property (nonatomic, copy)     NSString    *beginTime;
/** 提醒周期*/
@property (nonatomic, assign)   EvtEventCycleType      cycleType;
/** 自定义周期天数,可空*/
@property (nonatomic, copy)     NSString    *customCycleDay;
/** 备注*/
@property (nonatomic, copy)     NSString    *remarks;
/** 排序序号，小者靠前*/
@property (nonatomic, copy)     NSString    *orderNum;


@end
