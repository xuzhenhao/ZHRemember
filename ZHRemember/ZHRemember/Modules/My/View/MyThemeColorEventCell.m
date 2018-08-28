//
//  MyThemeColorEventCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/28.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyThemeColorEventCell.h"

@interface MyThemeColorEventCell()
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageView;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *timeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDayLabel;

@end

@implementation MyThemeColorEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}
- (void)setupView{
    self.shadowView.layer.cornerRadius = 4;
    self.shadowView.layer.shadowColor = [UIColor zh_shadowColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 4);
    self.shadowView.layer.shadowRadius = 5;
    self.shadowView.layer.shadowOpacity = 1;
    
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = YES;
    
    self.timeView.layer.cornerRadius = 5;
    self.timeView.layer.masksToBounds = YES;
}
- (void)updateWithColor:(UIColor *)color{
    self.bgimageView.backgroundColor = color;
    self.timeDayLabel.textColor = color;
    self.timeNumLabel.textColor = color;
}

@end
