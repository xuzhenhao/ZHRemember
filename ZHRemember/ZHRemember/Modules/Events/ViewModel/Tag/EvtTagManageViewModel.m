//
//  EvtTagManageViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtTagManageViewModel.h"
#import "EvtEventApi.h"

@interface EvtTagManageViewModel()

/** 数据源*/
@property (nonatomic, strong)   NSArray<EvtTagModel *>     *tagModels;

@end

@implementation EvtTagManageViewModel

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
        _delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [EvtEventApi deleteEventTag:input done:^(BOOL success, NSDictionary *result) {
                    [subscriber sendNext:@(success)];
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
                [EvtEventApi getPrivateTagListWithDone:^(NSArray<EvtTagModel *> *tagList, NSDictionary *result) {
                    
                    @strongify(self)
                    self.tagModels = tagList;
                    
                    [subscriber sendNext:nil];
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
                
                [EvtEventApi saveEventTag:tagModel done:^(BOOL success, NSDictionary *result) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _addCommand;
}
@end
