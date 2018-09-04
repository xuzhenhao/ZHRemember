//
//  IAPDiamondCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IAPDiamondCellViewModel;

@interface IAPDiamondCell : UITableViewCell

- (void)bindViewModel:(IAPDiamondCellViewModel *)viewModel;

@property (nonatomic, copy) void(^didClickBuyCallback)(NSString *goodsId);

@end
