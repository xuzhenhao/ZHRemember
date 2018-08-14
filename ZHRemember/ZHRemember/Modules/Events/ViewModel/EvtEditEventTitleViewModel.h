//
//  EvtEditEventTitleViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 编辑事件名cell对应vm
 */
@interface EvtEditEventTitleViewModel : NSObject

/** 事件名*/
@property (nonatomic, copy)     NSString    *eventName;

+ (instancetype)viewModelWithEventName:(NSString *)name;

@end
