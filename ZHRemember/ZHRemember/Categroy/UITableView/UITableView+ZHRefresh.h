//
//  UITableView+ZHRefresh.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/18.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ZHRefresh)

- (void)configHeadRefreshControlWithRefreshBlock:(void(^)(void))block;

@end
