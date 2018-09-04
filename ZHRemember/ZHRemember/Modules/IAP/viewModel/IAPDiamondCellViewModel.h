//
//  IAPDiamondCellViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPDiamondCellViewModel : NSObject

/** 商品标题*/
@property (nonatomic, copy,readonly)     NSString    *titleString;
/** 价格描述*/
@property (nonatomic, copy,readonly)     NSString    *priceString;
/** 商品id*/
@property (nonatomic, copy,readonly)     NSString    *goodsId;

+ (instancetype)viewModelWithTitle:(NSString *)title
                             price:(NSString *)price
                           goodsId:(NSString *)goodsId;

@end
