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
+ (void)changeRootViewController:(UIViewController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *snapView = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:YES];
        [controller.view addSubview:snapView];
        [UIApplication sharedApplication].delegate.window.rootViewController = controller;
        [UIView animateWithDuration:0.4 animations:^{
            snapView.transform = CGAffineTransformMakeTranslation(0, snapView.frame.size.height);
        } completion:^(BOOL finished) {
            [snapView removeFromSuperview];
        }];
    });
}
@end
