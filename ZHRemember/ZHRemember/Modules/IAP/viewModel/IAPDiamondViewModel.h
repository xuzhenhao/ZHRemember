//
//  IAPDiamondViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPDiamondCellViewModel.h"
/**开启去广告服务售价*/
extern NSInteger IAPDisableAdPrice;

@interface IAPDiamondViewModel : NSObject

/** 签到*/
@property (nonatomic, strong)   RACCommand     *signCommand;
/** 更新钱,参数为待增加的余额*/
@property (nonatomic, strong)   RACCommand     *addMoneyCommand;
/** 去广告*/
@property (nonatomic, strong)   RACCommand     *disableAdCommand;

/**
 获取执行操作后，奖励的数值

 @param action 操作id
 @return 返回待奖励的数值
 */
- (NSString *)getRewardMoneyForAction:(NSString *)action;
#pragma mark - tableView
- (NSInteger)numberOfSection;
- (NSInteger)numberOfrowsInSection:(NSInteger)section;
- (CGFloat)rowHeight;
- (IAPDiamondCellViewModel *)viewModelOfIndexPath:(NSIndexPath *)path;

@end
