//
//  ZHMediator+ZHLogin.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMediator+ZHLogin.h"

#define LoginModuleTargetName @"LGLoginTarget"

@implementation ZHMediator (ZHLogin)

- (UIViewController *)zh_registerViewController{
    UIViewController *vc = [self performTarget:LoginModuleTargetName action:@"registerViewController" params:nil];
    return vc ?: [UIViewController new];
}
@end
