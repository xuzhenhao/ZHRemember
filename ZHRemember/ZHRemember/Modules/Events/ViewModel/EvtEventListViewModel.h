//
//  EvtEventListViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    //EvtEventListSectionTop,//置顶
    EvtEventListSectionEvents,//普通事件列表
    //EvtEventListSectionRecommend,//推荐
} EvtEventListSection;

/**
 首页列表页对应的VM
 */
@interface EvtEventListViewModel : NSObject
/**加载数据*/
@property (nonatomic, strong)   RACCommand     *loadDataCommand;

#pragma mark - tableview datasource method
- (NSInteger)SectionCount;
- (NSInteger)rowCountForSection:(EvtEventListSection)section;
- (CGFloat)rowHeightForSection:(EvtEventListSection)section
                           row:(NSInteger)row;
- (NSString *)reuserIdForSection:(EvtEventListSection)section
                             row:(NSInteger)row;
- (id)viewModelForSection:(EvtEventListSection)section
                      row:(NSInteger)row;
- (id)modelForSection:(EvtEventListSection)section
                      row:(NSInteger)row;

@end
