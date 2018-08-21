//
//  EvtEditEventTagViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtTagModel.h"

/**事件标签VM*/
@interface EvtEditEventTagViewModel : NSObject

/** 当前标签文字描述*/
@property (nonatomic, copy,readonly)     NSString    *tagDesc;
/**当前标签*/
@property (nonatomic, strong,readonly)   EvtTagModel     *currentTag;

+ (instancetype)viewModelWithTag:(EvtTagModel *)currentTag;

/**
 选中新标签后更新标签

 @param index 选中标签的位置索引
 */
- (void)updateCurrentTagWithIndex:(NSInteger)index;
/**标签可选数*/
- (NSInteger)tagCount;
/**标签文字描述*/
- (NSString *)tagDescForRow:(NSInteger)row;

@end
