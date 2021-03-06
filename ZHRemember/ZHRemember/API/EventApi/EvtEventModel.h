//
//  EvtEventModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "EvtTagModel.h"

typedef enum : NSUInteger {
    EvtEventCycleNone = 0,//不重复
    EvtEventCycleDay,//每天
    EvtEventCycleWeek,//每周
    EvtEventCycleMonth,//每月
    EvtEventCycleYear,//每年
} EvtEventCycleType;

@interface EvtEventModel : MTLModel<MTLJSONSerializing>

/** 表主键id*/
@property (nonatomic, copy)     NSString    *objectId;
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
@property (nonatomic, assign)   EvtEventCycleType   cycleType;
/** 自定义周期天数,可空*/
@property (nonatomic, copy)     NSString    *customCycleDay;
/** 备注*/
@property (nonatomic, copy)     NSString    *remarks;
/** 排序序号，小者靠前*/
@property (nonatomic, copy)     NSString    *orderNum;
/** 标签模型*/
@property (nonatomic, strong)   EvtTagModel     *tagModel;
/** 是否推送提醒*/
@property (nonatomic, assign)   BOOL      isPush;
/** 是否置顶*/
@property (nonatomic, assign)   BOOL      isTop;

/**
 获取提醒周期的对应日历类型值
 */
- (NSCalendarUnit)CalendarUnitType;

@end
