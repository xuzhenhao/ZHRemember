//
//  IAPDiamondViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPDiamondCellViewModel.h"

@interface IAPDiamondViewModel : NSObject

/** 签到*/
@property (nonatomic, strong)   RACCommand     *signCommand;
/** 更新钱,需传入新的钱数*/
@property (nonatomic, strong)   RACCommand     *updateMoneyCommand;


/**
 获取执行操作后，增加后钱的值

 @param action 操作id
 @return 返回新的钱数
 */
- (NSString *)getRewardMoneyForAction:(NSString *)action;
#pragma mark - tableView
- (NSInteger)numberOfSection;
- (NSInteger)numberOfrowsInSection:(NSInteger)section;
- (CGFloat)rowHeight;
- (IAPDiamondCellViewModel *)viewModelOfIndexPath:(NSIndexPath *)path;

@end
