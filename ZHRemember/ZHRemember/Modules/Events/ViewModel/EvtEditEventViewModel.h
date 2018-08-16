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

/**
 EvtEditEventController对应的ViewModel
 */
@interface EvtEditEventViewModel : NSObject

/** 数据源*/
@property (nonatomic, strong)   NSArray     *dataSource;
/** 是否可以保存*/
@property (nonatomic, assign)   BOOL      isSaveEnable;

/** 选择照片*/
@property (nonatomic, strong)   RACSubject     *selectPhotoSubject;
/** 选择照片*/
@property (nonatomic, strong)   RACSubject     *selectDateSubject;

@property (nonatomic, strong)   RACCommand     *saveCommand;

@end
