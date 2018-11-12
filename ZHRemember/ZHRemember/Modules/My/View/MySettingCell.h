//
//  MySettingCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MySettingViewModel;

/**
 我的主页，设置类型cell
 */
@interface MySettingCell : UITableViewCell

- (void)bindViewModel:(MySettingViewModel *)viewModel;

@end
