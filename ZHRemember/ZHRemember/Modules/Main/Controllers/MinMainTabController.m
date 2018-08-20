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
    
    UINavigationController *eventsNC = [[UINavigationController alloc] initWithRootViewController:[[ZHMediator sharedInstance] eventListController]];
    eventsNC.tabBarItem.title = @"纪念日";
    eventsNC.tabBarItem.image = [UIImage imageNamed:@"tabbar-event-normal"];
    eventsNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar-event-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UINavigationController *settingNC = [[UINavigationController alloc] initWithRootViewController:[[ZHMediator sharedInstance] myViewController] ];
    settingNC.tabBarItem.title = @"我的";
    settingNC.tabBarItem.image = [UIImage imageNamed:@"tabbar-me-normal"];
    settingNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar-me-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.viewControllers = @[eventsNC,settingNC];
}


@end
