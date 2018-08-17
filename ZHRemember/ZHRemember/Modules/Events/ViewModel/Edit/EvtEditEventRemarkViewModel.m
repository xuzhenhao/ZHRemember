//
//  EvtEditEventRemarkViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventRemarkViewModel.h"

@implementation EvtEditEventRemarkViewModel

+ (instancetype)viewModelWithRemark:(NSString *)remark{
    EvtEditEventRemarkViewModel *vm = [EvtEditEventRemarkViewModel new];
    vm.remark = remark;
    
    return vm;
}

@end
