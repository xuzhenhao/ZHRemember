//
//  UIColor+ZHHex.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/17.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZHHex)
/**16进制字符串转颜色*/
+(UIColor *)zh_colorWithHexString:(NSString *)hexString;
- (NSString *)zh_hexString;

@end
