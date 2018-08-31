//
//  DIYDiaryListCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DIYDiaryListCellViewModel;

/**
 日记列表cell
 */
@interface DIYDiaryListCell : UITableViewCell

- (void)bindViewModel:(DIYDiaryListCellViewModel *)viewModel;

@end
