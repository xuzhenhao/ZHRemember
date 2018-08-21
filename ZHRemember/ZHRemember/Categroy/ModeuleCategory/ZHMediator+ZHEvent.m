//
//  ZHMediator+ZHEvent.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMediator+ZHEvent.h"

#define eventModuleTargetName @"EvtEventTarget"

@implementation ZHMediator (ZHEvent)

- (UIViewController *)eventListController{
    UIViewController *vc = [self performTarget:eventModuleTargetName action:@"eventListViewController" params:nil];
    return vc ?: [UIViewController new];
}
- (UIViewController *)eventTagController{
    UIViewController *vc = [self performTarget:eventModuleTargetName action:@"eventTagViewController" params:nil];
    return vc ?: [UIViewController new];
}
@end
