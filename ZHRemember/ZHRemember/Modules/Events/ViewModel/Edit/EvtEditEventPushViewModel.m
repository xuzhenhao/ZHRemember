//
//  EvtEditEventPushViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventPushViewModel.h"
#import "ZHAccessManager.h"

@implementation EvtEditEventPushViewModel
+ (instancetype)viewModelWithEnablePush:(BOOL)isEnable{
    EvtEditEventPushViewModel *vm = [EvtEditEventPushViewModel new];
    vm.isEnablePush = isEnable;
    return vm;
}
- (void)setIsEnablePush:(BOOL)isEnablePush{
    _isEnablePush = isEnablePush;
    if (isEnablePush) {
        //检查推送权限
        __weak typeof(self)weakself = self;
        [ZHAccessManager getPushAccess:^(BOOL isAccess,NSString *msg) {
            if (!isAccess) {
                [HBHUDManager showMessage:msg];
                weakself.isEnablePush = NO;
            }
        }];
    }
}
@end
