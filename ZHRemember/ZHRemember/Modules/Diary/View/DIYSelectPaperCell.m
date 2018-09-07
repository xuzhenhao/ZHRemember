//
//  DIYSelectPaperCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectPaperCell.h"

@interface DIYSelectPaperCell()
@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;

@end

@implementation DIYSelectPaperCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.paperImageView.layer.borderWidth = 0.5;
    self.paperImageView.layer.borderColor = [UIColor zh_lightGrayColor].CGColor;
}
- (void)updateWithImageName:(NSString *)name{
    self.paperImageView.image = [UIImage imageNamed:name];
}
@end
