//
//  EvtEditEventPushViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 推送提醒VM
 */
@interface EvtEditEventPushViewModel : NSObject
/** 是否推送提醒*/
@property (nonatomic, assign)   BOOL      isEnablePush;

+ (instancetype)viewModelWithEnablePush:(BOOL)isEnable;

@end
