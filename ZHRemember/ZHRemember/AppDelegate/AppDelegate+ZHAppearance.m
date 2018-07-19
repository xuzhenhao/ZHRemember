//
//  AppDelegate+ZHAppearance.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AppDelegate+ZHAppearance.h"
#import "ZHMediator+Main.h"

@implementation AppDelegate (ZHAppearance)

- (void)zh_setupWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ZHMediator sharedInstance] zh_mainTabbarController];
    [self.window makeKeyAndVisible];
}

@end
