//
//  MySettingCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MySettingCell.h"
#import "MySettingViewModel.h"

@interface MySettingCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation MySettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)bindViewModel:(MySettingViewModel *)viewModel{
    self.nameLabel.text = viewModel.name;
}


@end
