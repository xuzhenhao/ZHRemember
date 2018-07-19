//
//  ZHMediator+Main.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMediator+Main.h"

#define mainTarget @"MainTarget"

@implementation ZHMediator (Main)

- (UIViewController *)zh_mainTabbarController{
    UIViewController *vc = [[ZHMediator sharedInstance] performTarget:mainTarget action:@"mainTabbarController" params:nil];
    return vc ?: [UIViewController new];
}

@end
