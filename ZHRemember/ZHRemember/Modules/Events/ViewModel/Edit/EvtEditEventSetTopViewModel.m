//
//  EvtEditEventSetTopViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventSetTopViewModel.h"

@implementation EvtEditEventSetTopViewModel

+ (instancetype)viewModelWithTop:(BOOL)isTop{
    EvtEditEventSetTopViewModel *vm = [EvtEditEventSetTopViewModel new];
    vm.isTop = isTop;
    
    return vm;
}
@end
