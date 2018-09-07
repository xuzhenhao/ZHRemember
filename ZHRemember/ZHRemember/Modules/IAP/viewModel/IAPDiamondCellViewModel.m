//
//  IAPDiamondCellViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondCellViewModel.h"

NSString *const IAPEventBuySixRMB = @"xzh.remember6";
NSString *const IAPEventBuyEighteenRMB = @"IAPEventBuyEighteenRMB";
NSString *const IAPEventBuythirtyRMB = @"IAPEventBuythirtyRMB";
NSString *const IAPEventSign = @"IAPEventSign";
NSString *const IAPEventPublish = @"IAPEventPublish";
NSString *const IAPEventWatchAds = @"IAPEventWatchAds";

@interface IAPDiamondCellViewModel()
/** 商品标题*/
@property (nonatomic, copy)     NSString    *titleString;
/** 价格描述*/
@property (nonatomic, copy)     NSString    *priceString;
/** 商品id*/
@property (nonatomic, copy)     NSString    *eventId;

@end

@implementation IAPDiamondCellViewModel

+ (instancetype)viewModelWithTitle:(NSString *)title
                             price:(NSString *)price
                           eventId:(NSString *)eventId{
    IAPDiamondCellViewModel *viewModel = [IAPDiamondCellViewModel new];
    viewModel.titleString = title;
    viewModel.priceString = price;
    viewModel.eventId = eventId;
    
    return viewModel;
}
@end
