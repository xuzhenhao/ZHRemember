//
//  MyCustomColorViewController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自由选择颜色页面
 */
@interface MyCustomColorViewController : UIViewController

+ (instancetype)viewController;

@property (nonatomic, copy) void(^selectColorCallback)(UIColor *color);

@end
