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

    UIColor *cacheColor = [ZHGlobalStore getThemeColor];
    return cacheColor ? cacheColor : [UIColor zh_lightBlueColor];
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
#pragma mark - 常用颜色
+ (UIColor *)zh_lightGrayColor{
    return RGBColor(237, 239, 240);
}
+ (UIColor *)zh_lightBlueColor{
    return RGBColor(51, 204, 245);
}
+ (UIColor *)zh_greenColor{
    return RGBColor(92, 176, 133);
}
+ (UIColor *)zh_lightGreenColor{
    return RGBColor(51, 214, 187);
}
+ (UIColor *)zh_pinkColor{
    return RGBColor(249, 90, 125);
}
+ (UIColor *)zh_yellowColor{
    return RGBColor(249, 216, 106);
}
#pragma mark - tabbar
+ (UIColor *)zh_tabbarTextNormal{
    return RGBColor(102, 102, 102);
}
@end
