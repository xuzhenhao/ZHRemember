//
//  UITableViewCell+ZHViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ZHViewModel)

- (void)bindViewModel:(id)viewModel;

/**
 获取重用标识符
 */
+ (NSString *)reuseIdentify;

@end
