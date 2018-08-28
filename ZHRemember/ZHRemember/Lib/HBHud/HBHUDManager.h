//
//  HBHUDManager.h
//  HBTools
//
//  Created by Skyrim on 16/10/19.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBHUDManager : NSObject

#pragma mark - ProgressHUD

/**
 移除所有HUD
 */
+ (void)hideAllHUD;

/**
 *  显示提示消息
 *  @param message 消息内容
 */
+ (void)showMessage:(NSString *)message;

/**
 *  显示提示消息
 *  @param message     消息内容
 *  @param doneHandler 回调
 */
+ (void)showMessage:(NSString *)message done:(void(^)())doneHandler;

/**
 显示提示任务进行中消息
 @param message     消息内容
 @param doneHandler 完成回调
 */
+ (void)showIndeterminateMessage:(NSString *)message done:(void(^)())doneHandler;

/**
 显示提示自定义View和消息

 @param message     消息内容
 @param customView  自定义view
 @param doneHandler 完成回调
 */
+ (void)showCustomMessage:(NSString *)message customView:(UIView *)customView done:(void(^)())doneHandler;

/**
 显示网络加载HUD
 */
+ (void)showNetworkLoading;

/**
 移除网络加载HUD
 */
+ (void)hideNetworkLoading;

#pragma mark - Alert

/**
 *  使用系统样式显示提示消息
 *  @param message 消息内容
 */
+ (void)alertMessage:(NSString *)message;


@end
