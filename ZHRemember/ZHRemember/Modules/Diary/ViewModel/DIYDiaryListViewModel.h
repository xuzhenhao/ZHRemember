//
//  DIYDiaryListViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIYDiaryListCellViewModel.h"

/**日记列表页VM*/
@interface DIYDiaryListViewModel : NSObject

#pragma mark - UITableView
- (NSInteger)numOfRows;
- (id)viewModelOfRow:(NSInteger)row section:(NSInteger)section;
- (CGFloat)heightOfRow:(NSInteger)row section:(NSInteger)section;

/** 请求数据*/
@property (nonatomic, strong)   RACCommand     *requestCommand;

@end
