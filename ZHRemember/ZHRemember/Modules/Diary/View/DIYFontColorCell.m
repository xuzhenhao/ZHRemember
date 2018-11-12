//
//  DIYFontColorCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/18.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYFontColorCell.h"
#import "DIYFontColorModel.h"

@interface DIYFontColorCell()
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;
@property (weak, nonatomic) IBOutlet UIImageView *colorFulImageView;

@end

@implementation DIYFontColorCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}
- (void)updateView{
    self.lockImageView.hidden = self.colorModel.isLock ? NO : YES;
    self.colorFulImageView.hidden = self.colorModel.isCustomSelect ? NO: YES;
    self.backgroundColor = [UIColor zh_colorWithHexString:self.colorModel.hexColor];
    
}
- (void)setColorModel:(DIYFontColorModel *)colorModel{
    _colorModel = colorModel;
    [self updateView];
}
@end
