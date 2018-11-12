//
//  EvtEditEventTitleViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventTitleViewModel.h"

@implementation EvtEditEventTitleViewModel

+ (instancetype)viewModelWithEventName:(NSString *)name{
    EvtEditEventTitleViewModel *vm = [self new];
    vm.eventName = name;
    
    return vm;
}
@end
