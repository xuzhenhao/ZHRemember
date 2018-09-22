//
//  ZHThirdServiceConfig.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/22.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHThirdServiceConfig.h"

#pragma mar - Google Ads
NSString *AdMobId = @"ca-app-pub-2543232360111085~1498250203";
NSString *AdMobBannerId = @"ca-app-pub-2543232360111085/4202921700";
NSString *AdMobBannerTestId = @"ca-app-pub-3940256099942544/2934735716";
NSString *AdMobMovieId = @"ca-app-pub-2543232360111085/3185353504";
NSString *AdMobMovieTestId = @"ca-app-pub-3940256099942544/1712485313";


#pragma mark - ReanCloud&Umeng
#ifdef Pro
NSString *AVOSCloudAppId = @"GVNyhmwinRVaEnsvbALRFC0u-gzGzoHsz";
NSString *AVOSCloudAppkey = @"5ltwuDLDwxKOws9atwAl8MS6";
NSString *UMengAppId = @"5ba46204b465f5ce8b00023d";
#else
NSString *AVOSCloudAppId = @"Rv5XVMDxCfhGBekEcGENDBoE-gzGzoHsz";
NSString *AVOSCloudAppkey = @"y3cttoOTBQ4d4yc8Ccoood8l";
NSString *UMengAppId = @"5ba31320b465f56c140000bc";
#endif

NSString *AVOSCloudAppTestId = @"OWMbwAs72wWfNRHS51jV5Tso-gzGzoHsz";
NSString *AVOSCloudAppTestkey = @"LeFEoxaulIkxlIQx37YvadqU";

@implementation ZHThirdServiceConfig

@end
