//
//  EvtTagManageViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtTagModel.h"

@interface EvtTagManageViewModel : NSObject

/** 请求标签列表数据*/
@property (nonatomic, strong)   RACCommand     *requestCommand;
/** 新增标签数据*/
@property (nonatomic, strong)   RACCommand     *addCommand;
/** 删除标签*/
@property (nonatomic, strong)   RACCommand     *delCommand;

#pragma mark - tableView method
- (NSInteger)rows;
- (CGFloat)rowHeight;
- (EvtTagModel *)modelOfRow:(NSInteger)row;

@end
