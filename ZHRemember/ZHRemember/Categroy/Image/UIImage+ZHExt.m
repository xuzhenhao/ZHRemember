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
+ (UIImage *)zh_snapshotOfView:(UIView *)view{
    if (!view || view.bounds.size.width == 0 || view.bounds.size.height == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0);
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
