//
//  UIImage+ZHExt.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZHExt)
/**根据颜色生成相应尺寸的图片*/
+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size;

@end
