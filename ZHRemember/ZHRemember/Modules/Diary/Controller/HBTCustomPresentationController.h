//
//  HBTCustomPresentationController.h
//  aiyuebang
//
//  Created by cloud on 17/3/28.
//  Copyright © 2017年 haibao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 自定义的弹出控制器
 */
@interface HBTCustomPresentationController : UIPresentationController<UIViewControllerTransitioningDelegate>

/** 是否隐藏黑色遮罩*/
@property (nonatomic, assign)   BOOL      isHideMask;

@end
