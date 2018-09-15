//
//  EvtEventListViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListViewModel.h"
#import "EvtEventListEventsViewModel.h"
#import "EvtEventStore.h"
#import "ZHPushManager.h"

@interface EvtEventListViewModel()

@property (nonatomic, strong)   NSArray<EvtEventListEventsViewModel *>     *eventViewModels;
@property (nonatomic, strong)   NSError     *error;

@end

@implementation EvtEventListViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupObserver];
        
    }
    return self;
}

- (void)setupObserver{
    //监听model层
    @weakify(self)
    [[[RACObserve([EvtEventStore shared], events) skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.eventViewModels = [EvtEventListEventsViewModel viewModelsWithModels:x];
        [self.dataRefreshSubject sendNext:nil];
        [self _setupPushNotificationWithModel:x];
    }];
}
#pragma mark - private method
- (void)_setupPushNotificationWithModel:(NSArray<EvtEventModel *> *)models{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (EvtEventModel *model in models) {
            if (!model.isPush) {
                continue;
            }
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.beginTime integerValue]];
            //设置早上8：30推送
            date = [NSDate dateWithYear:date.year month:date.month day:date.day hour:[ZHGlobalStore getEventPushHour] minute:[ZHGlobalStore getEventPushMinute] second:0];
            NSString *msg = [NSString stringWithFormat:@"%@就在今天哦~",model.eventName];
            [ZHPushManager addLocalPushWithName:model.eventId date:date shouldRepead:model.cycleType repeat:[model CalendarUnitType] message:msg];
        }
    });
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
#pragma mark - getter
- (RACCommand *)loadDataCommand{
    if (!_loadDataCommand) {
        @weakify(self)
        _loadDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[EvtEventStore shared] loadDataWithPage:0 done:^(BOOL succeed, NSError *error) {
                    @strongify(self)
                    self.error = error;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _loadDataCommand;
}
- (RACSubject *)dataRefreshSubject{
    if (!_dataRefreshSubject) {
        _dataRefreshSubject = [RACSubject new];
    }
    return _dataRefreshSubject;
}
@end
