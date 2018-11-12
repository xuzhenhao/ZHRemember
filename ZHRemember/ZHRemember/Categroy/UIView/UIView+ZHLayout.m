//
//  UIView+ZHLayout.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "UIView+ZHLayout.h"

@implementation UIView (ZHLayout)

- (void)setZH_x:(CGFloat)ZH_x{
    CGRect frame = self.frame;
    frame.origin.x = ZH_x;
    self.frame = frame;
}

- (void)setZH_y:(CGFloat)ZH_y{
    CGRect frame = self.frame;
    frame.origin.y = ZH_y;
    self.frame = frame;
}

- (void)setZH_width:(CGFloat)ZH_width{
    CGRect frame = self.frame;
    frame.size.width = ZH_width;
    self.frame = frame;
}

- (void)setZH_height:(CGFloat)ZH_height{
    CGRect frame = self.frame;
    frame.size.height = ZH_height;
    self.frame = frame;
}

- (CGFloat)ZH_x{
    return self.frame.origin.x;
}

- (CGFloat)ZH_y{
    return self.frame.origin.y;
}

- (CGFloat)ZH_width{
    return self.frame.size.width;
}

- (CGFloat)ZH_height{
    return self.frame.size.height;
}

- (CGFloat)ZH_centerX{
    return self.center.x;
}
- (void)setZH_centerX:(CGFloat)ZH_centerX{
    CGPoint center = self.center;
    center.x = ZH_centerX;
    self.center = center;
}

- (CGFloat)ZH_centerY{
    return self.center.y;
}
- (void)setZH_centerY:(CGFloat)ZH_centerY{
    CGPoint center = self.center;
    center.y = ZH_centerY;
    self.center = center;
}

- (void)setZH_size:(CGSize)ZH_size{
    CGRect frame = self.frame;
    frame.size = ZH_size;
    self.frame = frame;
}
- (CGSize)ZH_size{
    return self.frame.size;
}


- (CGFloat)ZH_right{
    //    return self.ZH_x + self.ZH_width;
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)ZH_bottom{
    //    return self.ZH_y + self.ZH_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setZH_right:(CGFloat)ZH_right{
    self.ZH_x = ZH_right - self.ZH_width;
}
- (void)setZH_bottom:(CGFloat)ZH_bottom{
    self.ZH_y = ZH_bottom - self.ZH_height;
}

@end
