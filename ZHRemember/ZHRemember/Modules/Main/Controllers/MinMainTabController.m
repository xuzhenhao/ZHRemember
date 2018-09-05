//
//  MinMainTabController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MinMainTabController.h"
#import "ZHVersionManager.h"
#import "HBUpdateTipView.h"

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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self checkVersionUpdate];
}
#pragma mark - UI
- (void)initialSetup{
    
    UINavigationController *eventsNC = [[UINavigationController alloc] initWithRootViewController:[[ZHMediator sharedInstance] eventListController]];
    eventsNC.tabBarItem.title = @"纪念日";
    eventsNC.tabBarItem.image = [UIImage imageNamed:@"tabbar-event-normal"];
    eventsNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar-event-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UINavigationController *diaryNC = [[UINavigationController alloc] initWithRootViewController:[[ZHMediator sharedInstance] zh_diaryListViewController]];
    diaryNC.tabBarItem.title = @"日记本";
    diaryNC.tabBarItem.image = [UIImage imageNamed:@"tabbar-diary"];
    diaryNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar-diary"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UINavigationController *settingNC = [[UINavigationController alloc] initWithRootViewController:[[ZHMediator sharedInstance] myViewController] ];
    settingNC.tabBarItem.title = @"我的";
    settingNC.tabBarItem.image = [UIImage imageNamed:@"tabbar-me-normal"];
    settingNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar-me-high"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.viewControllers = @[eventsNC,diaryNC,settingNC];
}

#pragma mark - private method
- (void)checkVersionUpdate{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ZHVersionManager sharedManager] checkUpdateVersionWithDoneHandler:^(BOOL isNewVersion, NSString *versionDesc) {
            if (isNewVersion) {
                [HBUpdateTipView showWithTitle:@"升级提示" contents:versionDesc done:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppStoreLinkURL]];
                }];
            }
        }];
    });
}

@end
