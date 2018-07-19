//
//  UIImage+ZHExt.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "UIImage+ZHExt.h"

@implementation UIImage (ZHExt)

+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
