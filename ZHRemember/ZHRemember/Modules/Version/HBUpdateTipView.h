//
//  HBUpdateTipView.h
//  store
//
//  Created by cloud on 16/12/12.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 版本更新提示界面
 */
@interface HBUpdateTipView : UIView

/** 点击确定按钮后的回调事件*/
@property (nonatomic, copy) void(^confirmAction)();
/** 点击确定按钮后的回调事件*/
@property (nonatomic, copy) void(^cancelAction)();

/**
 弹出更新提示界面

 @param tipTitle 版本更新提示标题
 @param contents 版本更新提示内容
 */
- (void)showWithTitle:(NSString *)tipTitle contents:(NSString *)contents;
+ (void)showWithTitle:(NSString *)tipTitle contents:(NSString *)contents done:(void(^)(void))done;

@end
