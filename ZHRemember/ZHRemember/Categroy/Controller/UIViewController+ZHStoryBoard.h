//
//  UIViewController+ZHStoryBoard.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZHStoryBoard)

+ (instancetype)viewControllerWithStoryBoard:(NSString *)name;

/**
 切换根控制器

 @param controller 要切换为的控制器
 */
+ (void)changeRootViewController:(UIViewController *)controller;
/**切换根控制器为注册页*/
+ (void)changeRootToRegisterViewController;

@end
