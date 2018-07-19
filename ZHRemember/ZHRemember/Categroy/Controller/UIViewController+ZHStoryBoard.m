//
//  UIViewController+ZHStoryBoard.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "UIViewController+ZHStoryBoard.h"

@implementation UIViewController (ZHStoryBoard)
+ (instancetype)viewControllerWithStoryBoard:(NSString *)name{
   return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];;
}
@end
