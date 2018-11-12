//
//  EvtTagManageViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtTagManageViewModel.h"
#import "EvtEventStore.h"

@interface EvtTagManageViewModel()

/** 数据源*/
@property (nonatomic, strong)   NSArray<EvtTagModel *>     *tagModels;
/** 请求错误*/
@property (nonatomic, strong)   NSError     *error;

@end

@implementation EvtTagManageViewModel

- (instancetype)init{
    if (self == [super init]) {
        [self setupObserver];
    }
    return self;
}
- (void)setupObserver{
    @weakify(self)
    [[RACObserve([EvtEventStore shared], privateTags) filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.tagModels = x;
        [self.dataRefreshSubject sendNext:nil];
    }];
}
#pragma mark - tableView method
- (NSInteger)rows{
    return self.tagModels.count;
}
- (CGFloat)rowHeight{
    return 60;
}
- (EvtTagModel *)modelOfRow:(NSInteger)row{
    return self.tagModels[row];
}

#pragma mark - getter
- (RACCommand *)delCommand{
    if (!_delCommand) {
        @weakify(self)
        _delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                EvtTagModel *tag = input;
                [[EvtEventStore shared] deleteTagWithObjectId:tag.objectId tagId:tag.tagId done:^(BOOL succeed, NSError *error) {
                    @strongify(self)
                    self.error = error;
                    [subscriber sendNext:@(succeed)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _delCommand;
}
- (RACCommand *)requestCommand{
    if (!_requestCommand) {
        @weakify(self)
        
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[EvtEventStore shared] getEventTagsWithDone:^(BOOL succeed, NSError *error) {
                    @strongify(self)
                    self.error = error;
                    [subscriber sendNext:@(succeed)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    
    return _requestCommand;
}
- (RACCommand *)addCommand{
    if (!_addCommand) {
        @weakify(self)
        _addCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id input) {
            EvtTagModel *tagModel = nil;
            if ([input isKindOfClass:[EvtTagModel class]]) {
                //编辑修改
                tagModel = input;
            }else{
                //新增
                tagModel = [EvtTagModel new];
                tagModel.tagName = input;
            }
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[EvtEventStore shared] saveTag:tagModel done:^(BOOL succeed, NSError *error) {
                    @strongify(self)
                    self.error = error;
                    [subscriber sendNext:@(succeed)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _addCommand;
}
- (RACSubject *)dataRefreshSubject{
    if (!_dataRefreshSubject) {
        _dataRefreshSubject = [RACSubject new];
    }
    return _dataRefreshSubject;
}
@end
