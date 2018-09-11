//
//  EvtEventTarget.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvtEventTarget : NSObject

/**
 获取事件列表控制器
 */
- (UIViewController *)eventListViewController;

/**
 获取事件标签管理控制器
 */
- (UIViewController *)eventTagViewController;

@end
