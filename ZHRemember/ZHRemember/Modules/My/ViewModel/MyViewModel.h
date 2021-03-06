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
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (CGFloat)itemHeight;
- (MySettingViewModel *)viewModelForRow:(NSInteger)row section:(NSInteger)section;
- (MySettingType)itemTypeOfRow:(NSInteger)row section:(NSInteger)section;

#pragma mark - public method
- (void)logout;

/** 需要刷新回调*/
@property (nonatomic, strong)   RACSubject     *refreshSubject;

@end
