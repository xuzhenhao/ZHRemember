//
//  ZHThirdServiceConfig.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/22.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mar - Google Ads
extern NSString *AdMobId;
extern NSString *AdMobBannerId;//横幅类型的广告id
extern NSString *AdMobBannerTestId;//横幅类型的广告测试id
extern NSString *AdMobMovieId;//视频广告id
extern NSString *AdMobMovieTestId;//视频广告测试id

#pragma mark - ReanCloud&Umeng
extern NSString *AVOSCloudAppId;//融云存储服务
extern NSString *AVOSCloudAppkey;
extern NSString *AVOSCloudAppTestId;
extern NSString *AVOSCloudAppTestkey;

extern NSString *UMengAppId;//友盟分析

NS_ASSUME_NONNULL_BEGIN

/**
 第三方服务配置
 */
@interface ZHThirdServiceConfig : NSObject

@end

NS_ASSUME_NONNULL_END
