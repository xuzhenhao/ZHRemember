//
//  ZHIAPConfig.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/22.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHIAPConfig.h"

NSString *IAPSandboxURL = @"https://sandbox.itunes.apple.com/verifyReceipt";
NSString *IAPAppstoreURL = @"https://buy.itunes.apple.com/verifyReceipt";

#pragma mark - price
NSInteger IAPUnlockLetterPirce = 200;
NSInteger IAPUnlockFontPrice = 60;
NSInteger IAPUnlockFontColorPrice = 100;

#pragma mark - reward
NSInteger PublishDiaryReward = 5;

@implementation ZHIAPConfig

@end
