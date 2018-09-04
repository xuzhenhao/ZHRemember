//
//  IAPDiamondCellViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondCellViewModel.h"

@interface IAPDiamondCellViewModel()
/** 商品标题*/
@property (nonatomic, copy)     NSString    *titleString;
/** 价格描述*/
@property (nonatomic, copy)     NSString    *priceString;
/** 商品id*/
@property (nonatomic, copy)     NSString    *goodsId;

@end

@implementation IAPDiamondCellViewModel

+ (instancetype)viewModelWithTitle:(NSString *)title
                             price:(NSString *)price
                           goodsId:(NSString *)goodsId{
    IAPDiamondCellViewModel *viewModel = [IAPDiamondCellViewModel new];
    viewModel.titleString = title;
    viewModel.priceString = price;
    viewModel.goodsId = goodsId;
    
    return viewModel;
}
@end
