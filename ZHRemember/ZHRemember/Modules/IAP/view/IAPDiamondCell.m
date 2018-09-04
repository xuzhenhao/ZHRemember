//
//  IAPDiamondCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondCell.h"
#import "IAPDiamondCellViewModel.h"

@interface IAPDiamondCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
/** 商品id*/
@property (nonatomic, copy)     NSString    *goodsId;


@end

@implementation IAPDiamondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buyButton.layer.cornerRadius = 5;
    self.buyButton.layer.masksToBounds = YES;
    self.buyButton.layer.borderWidth = 0.5;
    self.buyButton.layer.borderColor = RGBColor(246, 196, 80).CGColor;
    
}

- (void)bindViewModel:(IAPDiamondCellViewModel *)viewModel{
    self.titleLabel.text = viewModel.titleString;
    [self.buyButton setTitle:viewModel.priceString forState:UIControlStateNormal];
    self.goodsId = viewModel.goodsId;
}
- (IBAction)didClickBuyButton:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    if (self.didClickBuyCallback) {
        self.didClickBuyCallback(self.goodsId);
    }
}


@end
