//
//  UIColor+ZHTheme.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZHTheme)
/**全局主题色*/
+ (UIColor *)zh_themeColor;
+ (UIColor *)zh_imagePlaceholdColor;
+ (UIColor *)zh_shadowColor;
+ (UIColor *)zh_coverColor;
+ (UIColor *)zh_tabbarColor;
+ (UIColor *)zh_navigationColor;
#pragma mark - 常用颜色
+ (UIColor *)zh_lightGrayColor;

#pragma mark - tabbar
+ (UIColor *)zh_tabbarTextNormal;

@end
