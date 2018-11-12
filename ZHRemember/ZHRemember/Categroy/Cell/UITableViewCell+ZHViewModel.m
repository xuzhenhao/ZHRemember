//
//  UITableViewCell+ZHViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "UITableViewCell+ZHViewModel.h"

@implementation UITableViewCell (ZHViewModel)

- (void)bindViewModel:(id)viewModel{
    
}
+ (NSString *)reuseIdentify{
    return NSStringFromClass([self class]);
}
@end
