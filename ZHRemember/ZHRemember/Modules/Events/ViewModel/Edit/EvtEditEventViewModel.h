//
//  EvtEditEventViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtEditEventTitleViewModel.h"
#import "EvtEditEventCoverViewModel.h"
#import "EvtEditEventDateViewModel.h"
#import "EvtEditEventCycleViewModel.h"
#import "EvtEditEventRemarkViewModel.h"
#import "EvtEditEventTagViewModel.h"

/**
 EvtEditEventController对应的ViewModel
 */
@interface EvtEditEventViewModel : NSObject

/** 数据源*/
@property (nonatomic, strong)   NSArray     *dataSource;
/** 是否可以保存*/
@property (nonatomic, assign)   BOOL      isSaveEnable;
/** 事件id*/
@property (nonatomic, copy,readonly)     NSString    *eventId;


/** 选择照片*/
@property (nonatomic, strong)   RACSubject     *selectPhotoSubject;
/** 选择照片*/
@property (nonatomic, strong)   RACSubject     *selectDateSubject;

@property (nonatomic, strong)   RACCommand     *saveCommand;

/**
 构造方法，必须采用此方法初始化

 @param model 原始数据，如编辑模式时传入原始数据
 @return 对象实例
 */
+ (instancetype)viewModelWithModel:(EvtEventModel *)model;

@end
