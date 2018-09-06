//
//  IAPDiamondCellViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const IAPEventBuySixRMB;//购买6元礼包
extern NSString *const IAPEventBuyEighteenRMB;//购买18元礼包
extern NSString *const IAPEventBuythirtyRMB;//购买30元礼包
extern NSString *const IAPEventSign;//签到
extern NSString *const IAPEventPublish;//发表日记
extern NSString *const IAPEventWatchAds;//看广告

@interface IAPDiamondCellViewModel : NSObject

/** 商品标题*/
@property (nonatomic, copy,readonly)     NSString    *titleString;
/** 价格描述*/
@property (nonatomic, copy,readonly)     NSString    *priceString;
/** 商品id*/
@property (nonatomic, copy,readonly)     NSString    *eventId;

+ (instancetype)viewModelWithTitle:(NSString *)title
                             price:(NSString *)price
                           eventId:(NSString *)eventId;

@end
