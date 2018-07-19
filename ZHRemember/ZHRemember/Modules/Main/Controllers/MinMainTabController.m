//
//  MinMainTabController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MinMainTabController.h"

@interface MinMainTabController ()

@end

@implementation MinMainTabController

+ (instancetype)tabbarController{
    return [MinMainTabController new];
}
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - UI
- (void)initialSetup{
    UINavigationController *eventsNC = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    eventsNC.tabBarItem.title = @"记忆点";
    
    UINavigationController *settingNC = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    settingNC.tabBarItem.title = @"我的";
    
    
    self.viewControllers = @[eventsNC,settingNC];
}



@end
