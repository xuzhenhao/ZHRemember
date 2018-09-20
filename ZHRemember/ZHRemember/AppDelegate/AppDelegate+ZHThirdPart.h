//
//  AppDelegate+ZHThirdPart.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (ZHThirdPart)

/**
 启动友盟服务
 */
- (void)zh_setupUmengService;
/**
 启动融云服务
 */
- (void)zh_setupLeanCloudService;

/**
 启动广告服务
 */
- (void)zh_setupAdmobService;

/**
 本地推送服务
 */
- (void)zh_setupLocalPushService;

@end
