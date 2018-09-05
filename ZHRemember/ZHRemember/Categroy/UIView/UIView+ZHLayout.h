//
//  UIView+ZHLayout.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHLayout)

@property (nonatomic ,assign) CGFloat ZH_x;
@property (nonatomic ,assign) CGFloat ZH_y;
@property (nonatomic ,assign) CGFloat ZH_width;
@property (nonatomic ,assign) CGFloat ZH_height;
@property (nonatomic ,assign) CGFloat ZH_centerX;
@property (nonatomic ,assign) CGFloat ZH_centerY;

@property (nonatomic ,assign) CGSize ZH_size;

@property (nonatomic, assign) CGFloat ZH_right;
@property (nonatomic, assign) CGFloat ZH_bottom;

@end
