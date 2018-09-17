//
//  ZHMacro.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHNotificationConfig.h"
#import "ZHFontConfig.h"

#pragma mark - Macro
#define ZHScreenWidth [UIScreen mainScreen].bounds.size.width
#define ZHScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZHNavbarHeight  (ZHStatusbarHeight + 44)
#define ZHTabbarHeight   ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define ZHStatusbarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define ZHStatusBarMargin (HBStatusbarHeight - 20)
#define ZHTabbarMargin ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.0]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#pragma mar - Ads
extern NSString *AppStoreLinkURL;//appstore的链接地址
extern NSString *AdMobId;
extern NSString *AdMobBannerId;//横幅类型的广告id
extern NSString *AdMobBannerTestId;//横幅类型的广告测试id
extern NSString *AdMobMovieId;//视频广告id
extern NSString *AdMobMovieTestId;//视频广告测试id
#pragma mark - IAP
extern NSString *IAPSandboxURL;//沙盒测试环境验证
extern NSString *IAPAppstoreURL;//正式环境验证

extern NSInteger IAPUnlockLetterPirce;//解锁信纸费用
#pragma mark - error
extern NSString *NSErrorDescKey;//错误描述的key

#pragma mark - reward
extern NSInteger PublishDiaryReward;//发布日记奖励

@interface ZHMacro : NSObject

@end
