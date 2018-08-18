//
//  EvtEventListViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListViewModel.h"
#import "EvtEventListEventsViewModel.h"
#import "EvtEventApi.h"

@interface EvtEventListViewModel()

@property (nonatomic, strong)   NSArray<EvtEventListEventsViewModel *>     *eventViewModels;
@end

@implementation EvtEventListViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self racConfig];
    }
    return self;
}

- (void)racConfig{
    @weakify(self)
    
    _loadDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [EvtEventApi getEventListsWithPage:0 done:^(NSArray<EvtEventModel *> *eventLists, NSDictionary *result) {
                @strongify(self)
                self.eventViewModels = [EvtEventListEventsViewModel viewModelsWithModels:eventLists];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
}
#pragma mark - tableview datasource method
- (NSInteger)SectionCount{
    return 1;
}
- (NSInteger)rowCountForSection:(EvtEventListSection)EvtEventListSection{
    NSInteger rowCount = 0;
    
    switch (EvtEventListSection) {
        case EvtEventListSectionEvents:
            rowCount = self.eventViewModels.count;
            break;
    }
    return rowCount;
}
- (CGFloat)rowHeightForSection:(EvtEventListSection)section row:(NSInteger)row{
    CGFloat rowHeight = 0;
    
    switch (section) {
        case EvtEventListSectionEvents:
            //上下留白+图片高度+下方内容高度
            rowHeight = 40 + (ZHScreenWidth - 40) * 9 / 16 + 142;
            break;
            
    }
    return rowHeight;
}
- (NSString *)reuserIdForSection:(EvtEventListSection)section
                             row:(NSInteger)row{
    NSString *reuseId = nil;
    
    switch (section) {
        case EvtEventListSectionEvents:
            reuseId = @"EvtEventListCell";
            break;
    }
    
    return reuseId;
}
- (id)viewModelForSection:(EvtEventListSection)section
                      row:(NSInteger)row{
    id viewModel = nil;
    
    switch (section) {
        case EvtEventListSectionEvents:
            viewModel = self.eventViewModels[row];
            break;
    }
    
    return viewModel;
}
- (id)modelForSection:(EvtEventListSection)section
                  row:(NSInteger)row{
    id model = nil;
    
    switch (section) {
        case EvtEventListSectionEvents:{
            EvtEventListEventsViewModel *viewModel = self.eventViewModels[row];
            model = [viewModel getModelData];
        }
            
            break;
    }
    
    return model;
}
@end
