//
//  UIViewController+ZHStoryBoard.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZHStoryBoard)

+ (instancetype)viewControllerWithStoryBoard:(NSString *)name;

@end
