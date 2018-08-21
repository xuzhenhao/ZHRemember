//
//  EvtEventListEventsViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtEventModel.h"

@interface EvtEventListEventsViewModel : NSObject

@property (nonatomic, copy)     NSString    *coverURLStr;
@property (nonatomic, copy)     NSString    *eventName;
/** 提醒时间.没有设置重复提醒则显示总天数，设置了重复提醒则显示距离下一个周期的天数*/
@property (nonatomic, copy)     NSString    *remindTime;
/** 已经发生的，显示"已经"，将来发生的，显示"还剩"*/
@property (nonatomic, copy)     NSString    *remindTypeTips;

/** 事件开始时间*/
@property (nonatomic, copy)     NSString    *beginTime;
/** 星期几*/
@property (nonatomic, copy)     NSString    *weekTime;
/** 留言*/
@property (nonatomic, copy)     NSString    *remark;
/** 标签*/
@property (nonatomic, copy)     NSString    *tagName;


+ (instancetype)viewModelWithModel:(EvtEventModel *)model;
+ (NSArray<EvtEventListEventsViewModel *> *)viewModelsWithModels:(NSArray<EvtEventModel *> *)models;
/**获取原始model数据,返回的为副本*/
- (EvtEventModel *)getModelData;

@end
