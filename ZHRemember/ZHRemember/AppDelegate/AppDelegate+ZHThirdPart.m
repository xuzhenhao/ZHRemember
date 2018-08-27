//
//  AppDelegate+ZHThirdPart.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AppDelegate+ZHThirdPart.h"
#import <AVOSCloud/AVOSCloud.h>

#define AVOSCloudAppId @"OWMbwAs72wWfNRHS51jV5Tso-gzGzoHsz"
#define AVOSCloudAppkey @"LeFEoxaulIkxlIQx37YvadqU"

@implementation AppDelegate (ZHThirdPart)

- (void)zh_setupLeanCloudService{
    [AVOSCloud setApplicationId:AVOSCloudAppId clientKey:AVOSCloudAppkey];
    [AVOSCloud setAllLogsEnabled:NO];
}

@end
