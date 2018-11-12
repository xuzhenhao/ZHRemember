//
//  DIYSelectMoodCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/1.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectMoodCell.h"


@interface DIYSelectMoodCell()

@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end

@implementation DIYSelectMoodCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.selectedView.layer.cornerRadius = 5;
    self.selectedView.layer.masksToBounds = YES;
    self.selectedView.layer.borderColor = [UIColor zh_lightGrayColor].CGColor;
    self.selectedView.layer.borderWidth = 0.5;
}

- (void)updateWithIndexPath:(NSIndexPath *)path isSelected:(BOOL)isSelected{
    NSInteger section = path.section;
    NSInteger row = path.row;
    
    NSString *imageName = nil;
    switch (section) {
        case 0:
            imageName = [NSString diary_moodImageNameOfIndex:row];
            break;
        case 1:
            imageName = [NSString diary_weatherImageNameOfIndex:row];
            break;
        default:
            break;
    }
    
    self.moodImageView.image = [UIImage imageNamed:imageName];
    if (isSelected) {
        self.selectedView.hidden = NO;
    }else{
        self.selectedView.hidden = YES;
    }
}
@end
