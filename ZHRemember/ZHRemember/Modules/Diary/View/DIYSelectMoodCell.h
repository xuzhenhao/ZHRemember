//
//  DIYSelectMoodCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/1.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选择心情、天气图片cell
 */
@interface DIYSelectMoodCell : UICollectionViewCell

- (void)updateWithIndexPath:(NSIndexPath *)path isSelected:(BOOL)isSelected;

@end
