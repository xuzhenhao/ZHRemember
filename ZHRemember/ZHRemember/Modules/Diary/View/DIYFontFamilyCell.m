//
//  DIYFontFamilyCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYFontFamilyCell.h"
#import "DIYFontFamilyModel.h"

@interface DIYFontFamilyCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@end

@implementation DIYFontFamilyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.unlockButton.layer.cornerRadius = 5;
    self.unlockButton.layer.masksToBounds = YES;
    self.unlockButton.layer.borderColor = [UIColor zh_themeColor].CGColor;
    self.unlockButton.layer.borderWidth = 0.5;
}

- (void)updateView{
    self.contentLabel.font = [UIFont fontWithName:self.model.fontName size:20];
    if (self.model.isLock) {
        self.unlockButton.hidden = NO;
    }else{
        self.unlockButton.hidden = YES;
    }
}
- (void)setModel:(DIYFontFamilyModel *)model{
    _model = model;
    [self updateView];
}

@end
