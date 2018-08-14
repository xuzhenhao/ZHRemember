//
//  AppDelegate+ZHAppearance.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AppDelegate+ZHAppearance.h"

@implementation AppDelegate (ZHAppearance)

- (void)zh_setupWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ZHMediator sharedInstance] zh_mainTabbarController];
    [self.window makeKeyAndVisible];
}
- (void)zh_setupAppearance{
    [self zh_setupNavigationAppearance];
    [self zh_setupTabbarAppearance];
    [self iOS11Config];
}
- (void)zh_setupTabbarAppearance{
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setTintColor:[UIColor zh_themeColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zh_tabbarTextNormal]}forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor zh_themeColor]} forState:UIControlStateSelected];
}
- (void)zh_setupNavigationAppearance{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBackgroundImage:
     [UIImage zh_imageWithColor:[UIColor zh_themeColor] size:CGSizeMake(1, 1)]
                           forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}
- (void)iOS11Config{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
}

@end