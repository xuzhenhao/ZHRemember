//
//  DIYDiaryListViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryListViewModel.h"
#import "DIYDiaryStore.h"

@interface DIYDiaryListViewModel()
/** <#desc#>*/
@property (nonatomic, strong)   NSArray<DIYDiaryListCellViewModel *>     *diaryViewModels;

@property (nonatomic, strong)   NSError     *error;

@end

@implementation DIYDiaryListViewModel

- (instancetype)init{
    if (self == [super init]) {
        [self setupObserver];
    }
    return self;
}
- (void)setupObserver{
    @weakify(self)
    [RACObserve([DIYDiaryStore shared], diarys) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self refreshDataWithModels:x];
        [self.refreshSubject sendNext:nil];
    }];
}

#pragma mark - UITableView
- (NSInteger)numOfRows{
    return self.diaryViewModels.count;
}
- (DIYDiaryListCellViewModel *)viewModelOfRow:(NSInteger)row section:(NSInteger)section{
    return self.diaryViewModels[row];
}
- (CGFloat)heightOfRow:(NSInteger)row section:(NSInteger)section{
    DIYDiaryListCellViewModel *viewModel = [self viewModelOfRow:row section:section];
    
    return viewModel.cellHeight;
}

#pragma mark - utils
- (NSArray<DIYDiaryListCellViewModel *> *)adapterViewModelsWithModels:(NSArray<ZHDiaryModel *> *)diaryList{
    NSMutableArray *tempM = [NSMutableArray array];
    
    ZHDiaryModel *lastModel = nil;
    for (ZHDiaryModel *model in diaryList) {
        DIYDiaryListCellViewModel *viewModel = [DIYDiaryListCellViewModel viewModelWithModel:model];
//        viewModel.isShowHeadTime = ![self isFirstTime:lastModel.unixTime isSameToTime:model.unixTime];
        [self calcuteViewModelTimeWithVM:viewModel VMTime:model.unixTime lastTime:lastModel.unixTime];
        lastModel = model;
        
        [tempM addObject:viewModel];
    }
    
    return [tempM copy];
}
/**更新数据*/
- (void)refreshDataWithModels:(NSArray<ZHDiaryModel *> *)diaryList{
    NSArray<DIYDiaryListCellViewModel *> *viewModels = [self adapterViewModelsWithModels:diaryList];
        self.diaryViewModels = viewModels;
}
/**同月份的，不显示月份信息。同一天的，不显示天信息*/
- (void)calcuteViewModelTimeWithVM:(DIYDiaryListCellViewModel *)viewModel VMTime:(NSString *)vmTime lastTime:(NSString *)lastTime{
    if (!lastTime) {
        viewModel.isShowHeadTime = YES;
        viewModel.isShowDayTime = YES;
        return;
    }
    NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:[vmTime integerValue]];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:[lastTime integerValue]];
    if (firstDate.month == secondDate.month) {
        viewModel.isShowHeadTime = NO;
        if ([firstDate isSameDay:secondDate]) {
            viewModel.isShowDayTime = NO;
        }else{
            viewModel.isShowDayTime = YES;
        }
    }else{
        viewModel.isShowHeadTime = YES;
        viewModel.isShowDayTime = YES;
    }
    
}
- (BOOL)isFirstTime:(NSString *)firstTime isSameToTime:(NSString *)secondTime{
    NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:[firstTime integerValue]];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:[secondTime integerValue]];
    return [firstDate isSameDay:secondDate];
}

#pragma mark - getter
- (RACCommand *)requestCommand{
    if (!_requestCommand) {
        @weakify(self)
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[DIYDiaryStore shared] loadDataWithPage:0 done:^(BOOL succeed, NSError *error) {
                    @strongify(self)
                    self.error = error;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _requestCommand;
}
- (RACSubject *)refreshSubject{
    if (!_refreshSubject) {
        _refreshSubject = [RACSubject new];
    }
    return _refreshSubject;
}
@end
