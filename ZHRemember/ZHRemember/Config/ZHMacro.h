//
//  ZHMacro.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZHScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZHScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZHNavbarHeight  (ZHStatusbarHeight + 44)
#define ZHTabbarHeight   ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define ZHStatusbarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define ZHStatusBarMargin (HBStatusbarHeight - 20)
#define ZHTabbarMargin ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ZHMacro : NSObject

@end
