//
//  ZHMacro.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMacro.h"

#ifdef Pro
NSString *AppStoreLinkURL = @"https://itunes.apple.com/cn/app/id1436942874?mt=8";
#else
NSString *AppStoreLinkURL = @"https://itunes.apple.com/cn/app/id1435122591?mt=8";
#endif

#pragma mark - error
NSString *NSErrorDescKey = @"NSLocalizedDescription";

#pragma mark - zone code
NSString *ChinaZoneCode = @"86";
NSString *XiangGangZoneCode = @"852";
NSString *TaiWangZoneCode = @"886";
NSString *AoMengZoneCode = @"853";

@implementation ZHMacro

@end
