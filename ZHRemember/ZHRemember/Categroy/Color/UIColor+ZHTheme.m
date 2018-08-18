//
//  UIColor+ZHTheme.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "UIColor+ZHTheme.h"

@implementation UIColor (ZHTheme)

+ (UIColor *)zh_themeColor{
//
    return RGBColor(249, 216, 106);
//    return [UIColor whiteColor];
}
+ (UIColor *)zh_tabbarColor{
    return RGBColor(249, 216, 106);
}
+ (UIColor *)zh_navigationColor{
    return [UIColor whiteColor];
}
+ (UIColor *)zh_coverColor{
    return RGBColor(51, 204, 245);
}
+ (UIColor *)zh_imagePlaceholdColor{
    return RGBColor(224, 224, 224);
}
+ (UIColor *)zh_shadowColor{
    return RGBAColor(240, 240, 240, 0.6);
}
#pragma mark - tabbar
+ (UIColor *)zh_tabbarTextNormal{
    return RGBColor(102, 102, 102);
}
@end
