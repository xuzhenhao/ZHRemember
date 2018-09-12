//
//  EvtEditEventViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventViewModel.h"
#import "ZHTableViewItem.h"
#import "EvtEventStore.h"

@interface EvtEditEventViewModel()
@property (nonatomic, assign)   BOOL      isShowDeleteItem;
@property (nonatomic, strong)   NSError     *error;

/** 用于封装网络请求的数据*/
@property (nonatomic, strong)   EvtEventModel     *eventModel;

@end

@implementation EvtEditEventViewModel
+ (instancetype)viewModelWithModel:(EvtEventModel *)model{
    EvtEditEventViewModel *vm = [EvtEditEventViewModel new];
    vm.isShowDeleteItem = model ? YES : NO;
    
    [vm initConfigWithModel:model];
    [vm racConfig];
    
    return vm;
}

- (void)initConfigWithModel:(EvtEventModel *)model{
    self.eventModel.eventId = model.eventId;
    
    EvtEditEventTitleViewModel *titleVM = [EvtEditEventTitleViewModel viewModelWithEventName:model.eventName];
    
    EvtEditEventCoverViewModel *coverVM = [EvtEditEventCoverViewModel viewModelWithCoverURL:model.coverURLStr];
    coverVM.selectPhotoSubject = self.selectPhotoSubject;
    
    EvtEditEventDateViewModel *dateVM = [EvtEditEventDateViewModel viewModelWithDate:model.beginTime];
    dateVM.selectDateSubject = self.selectDateSubject;
    
    EvtEditEventCycleViewModel *cycleVM = [EvtEditEventCycleViewModel viewModelWithCycleType:model.cycleType];
    
    EvtEditEventTagViewModel *tagVM = [EvtEditEventTagViewModel viewModelWithTag:model.tagModel];
    
    EvtEditEventRemarkViewModel *remarkVM = [EvtEditEventRemarkViewModel viewModelWithRemark:model.remarks];
    
    NSArray *contents = @[
                          [ZHTableViewItem itemWithData:titleVM reuserId:@"EvtEditEventTitleCell" height:60],
                          [ZHTableViewItem itemWithData:coverVM reuserId:@"EvtEditEventCoverCell" height:100],
                          [ZHTableViewItem itemWithData:dateVM reuserId:@"EvtEditEventDateCell" height:60],
                          [ZHTableViewItem itemWithData:cycleVM reuserId:@"EvtEditEventCycleCell" height:60],
                          [ZHTableViewItem itemWithData:tagVM reuserId:@"EvtEditEventTagCell" height:60],
                          [ZHTableViewItem itemWithData:remarkVM reuserId:@"EvtEditEventRemarkCell" height:60]
                          ];
    self.dataSource = contents;
    
    RAC(self,isSaveEnable) = [[RACSignal combineLatest:@[
                                                        RACObserve(titleVM, eventName)
                                                        ,RACObserve(dateVM, dateFormat)
                                                        ]] map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSString *eventName,NSString *dateString) = value;
        return @(eventName && dateString && eventName.length > 0 && dateString.length > 0);
    }];
    RAC(self.eventModel,eventName) = RACObserve(titleVM, eventName);
    RAC(self.eventModel,remarks) = RACObserve(remarkVM, remark);
    RAC(self.eventModel,beginTime) = RACObserve(dateVM, unixTime);
    RAC(self.eventModel,coverURLStr) = RACObserve(coverVM, coverURLString);
    RAC(self.eventModel,cycleType) = RACObserve(cycleVM, cycleType);
    RAC(self.eventModel,tagModel) = RACObserve(tagVM, currentTag);
}

- (void)racConfig{
    
    
}


#pragma mark - getter&setter
- (RACCommand *)saveCommand{
    if (!_saveCommand) {
        @weakify(self);
        _saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                if (self.eventModel.eventId) {
                    //更新事件
                    [[EvtEventStore shared] updateWithEvent:self.eventModel done:^(BOOL succeed, NSError *error) {
                        self.error = error;
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }];
                }else{
                    //新增事件
                    [[EvtEventStore shared] addWithEvent:self.eventModel done:^(BOOL succeed, NSError *error) {
                        self.error = error;
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                    }];
                }
                
                return nil;
            }];
        }];
    }
    return _saveCommand;
}
- (RACCommand *)deleteCommand{
    if (!_deleteCommand) {
        @weakify(self)
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [[EvtEventStore shared] deleteWithEventId:self.eventId done:^(BOOL succeed, NSError *error) {
                    self.error = error;
                    [subscriber sendNext:@(succeed)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _deleteCommand;
}
- (RACSubject *)selectPhotoSubject{
    if (!_selectPhotoSubject) {
        _selectPhotoSubject = [RACSubject subject];
    }
    return _selectPhotoSubject;
}
- (RACSubject *)selectDateSubject{
    if (!_selectDateSubject) {
        _selectDateSubject = [RACSubject subject];
    }
    return _selectDateSubject;
}
- (EvtEventModel *)eventModel{
    if (!_eventModel) {
        _eventModel = [EvtEventModel new];
    }
    return _eventModel;
}
- (NSString *)eventId{
    return self.eventModel.eventId;
}
@end
