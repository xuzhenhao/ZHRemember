//
//  MyViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySettingViewModel.h"

/**
 我的主页，viewModel
 */
@interface MyViewModel : NSObject

#pragma mark - tableView
- (NSInteger)numberOfItems;
- (CGFloat)itemHeight;
- (id)viewModelForRow:(NSInteger)row section:(NSInteger)section;
- (MySettingType)itemTypeOfRow:(NSInteger)row section:(NSInteger)section;

#pragma mark - public method
- (void)logout;

@end
