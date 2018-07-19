//
//  MainTarget.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MainTarget.h"
#import "MinMainTabController.h"

@implementation MainTarget

- (UIViewController *)mainTabbarController{
    UIViewController *vc = [MinMainTabController tabbarController];
    return vc;
}

@end
