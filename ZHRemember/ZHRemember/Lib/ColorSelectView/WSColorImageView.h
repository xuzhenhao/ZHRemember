//
//  WSColorImageView.h
//  1111
//
//  Created by iMac on 16/12/12.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>
/**提供用户触摸选择颜色*/
@interface WSColorImageView : UIImageView
/**选择的颜色回调*/
@property (copy, nonatomic) void(^currentColorBlock)(UIColor *color,NSString *rgbStr);

@end
