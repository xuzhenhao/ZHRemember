//
//  ZHMediator+My.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMediator+My.h"

#define myModuleTargetName @"MyTarget"

@implementation ZHMediator (My)

- (UIViewController *)myViewController{
    UIViewController *vc = [self performTarget:myModuleTargetName action:@"myViewController" params:nil];
    return vc ?: [UIViewController new];
}
@end
