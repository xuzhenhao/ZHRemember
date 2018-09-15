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
#import "EvtEditEventPushViewModel.h"
#import "EvtEditEventSetTopViewModel.h"

/**
 EvtEditEventController对应的ViewModel
 */
@interface EvtEditEventViewModel : NSObject
/** 是否显示删除按钮*/
@property (nonatomic, assign,readonly)   BOOL      isShowDeleteItem;
/** 请求错误*/
@property (nonatomic, strong,readonly)   NSError     *error;
/** 数据源*/
@property (nonatomic, strong,readonly)   NSArray     *dataSource;
/** 是否可以保存*/
@property (nonatomic, assign,readonly)   BOOL      isSaveEnable;

/** 选择照片*/
@property (nonatomic, strong)   RACSubject     *selectPhotoSubject;
/** 上传照片回调*/
@property (nonatomic, strong)   RACSubject     *uploadPhotoSubject;
/** 选择日期*/
@property (nonatomic, strong)   RACSubject     *selectDateSubject;
/**保存*/
@property (nonatomic, strong)   RACCommand     *saveCommand;
/** 删除*/
@property (nonatomic, strong)   RACCommand     *deleteCommand;

/**
 构造方法，必须采用此方法初始化

 @param model (可选)原始数据，如编辑模式时传入原始数据
 @return 对象实例
 */
+ (instancetype)viewModelWithModel:(EvtEventModel *)model;

@end
