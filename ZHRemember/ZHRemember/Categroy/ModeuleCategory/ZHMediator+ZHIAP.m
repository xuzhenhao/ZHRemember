//
//  ZHMediator+ZHIAP.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMediator+ZHIAP.h"

#define IAPModuleTargetName @"IAPTarget"

@implementation ZHMediator (ZHIAP)

- (UIViewController *)zh_diamondViewController{
    UIViewController *vc = [self performTarget:IAPModuleTargetName action:@"diamondViewController" params:nil];
    return vc ?: [UIViewController new];
}

@end
