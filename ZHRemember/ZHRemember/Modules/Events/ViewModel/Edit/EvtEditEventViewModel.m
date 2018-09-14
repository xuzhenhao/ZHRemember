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
@property (nonatomic, assign)   BOOL      isSaveEnable;
@property (nonatomic, strong)   NSError     *error;

/** 用于封装网络请求的数据*/
@property (nonatomic, strong)   EvtEventModel     *eventModel;

/** 事件名VM*/
@property (nonatomic, strong)   EvtEditEventTitleViewModel     *titleVM;
/** 封面VM*/
@property (nonatomic, strong)   EvtEditEventCoverViewModel     *coverVM;
/** 日期VM*/
@property (nonatomic, strong)   EvtEditEventDateViewModel     *dateVM;
/** 重复周期VM*/
@property (nonatomic, strong)   EvtEditEventCycleViewModel     *cycleVM;
/** 标签VM*/
@property (nonatomic, strong)   EvtEditEventTagViewModel     *tagVM;
/** 留言VM*/
@property (nonatomic, strong)   EvtEditEventRemarkViewModel     *remarkVM;
/** 推送提醒*/
@property (nonatomic, strong)   EvtEditEventPushViewModel     *pushVM;

@end

@implementation EvtEditEventViewModel
+ (instancetype)viewModelWithModel:(EvtEventModel *)model{
    EvtEditEventViewModel *vm = [EvtEditEventViewModel new];
    vm.isShowDeleteItem = model ? YES : NO;
    vm.eventModel.objectId = model.objectId;
    vm.eventModel.eventId = model.eventId;
    
    [vm setupViewModelWithModel:model];
    [vm setupObserver];
    
    return vm;
}

- (void)setupViewModelWithModel:(EvtEventModel *)model{
    
    _titleVM = [EvtEditEventTitleViewModel viewModelWithEventName:model.eventName];
    
    _coverVM = [EvtEditEventCoverViewModel viewModelWithCoverURL:model.coverURLStr];
    _coverVM.selectPhotoSubject = self.selectPhotoSubject;
    _coverVM.uploadPhotoSubject = self.uploadPhotoSubject;
    
    _dateVM = [EvtEditEventDateViewModel viewModelWithDate:model.beginTime];
    _dateVM.selectDateSubject = self.selectDateSubject;
    
    _cycleVM = [EvtEditEventCycleViewModel viewModelWithCycleType:model.cycleType];
    
    _tagVM = [EvtEditEventTagViewModel viewModelWithTag:model.tagModel];
    
    _remarkVM = [EvtEditEventRemarkViewModel viewModelWithRemark:model.remarks];
    
    _pushVM = [EvtEditEventPushViewModel viewModelWithEnablePush:model.isPush];
    
}

- (void)setupObserver{
    RAC(self,isSaveEnable) = [[RACSignal combineLatest:@[
                                                         RACObserve(_titleVM, eventName)
                                                         ,RACObserve(_dateVM, dateFormat)
                                                         ]] map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSString *eventName,NSString *dateString) = value;
        return @(eventName && dateString && eventName.length > 0 && dateString.length > 0);
    }];
    RAC(self.eventModel,eventName) = RACObserve(_titleVM, eventName);
    RAC(self.eventModel,remarks) = RACObserve(_remarkVM, remark);
    RAC(self.eventModel,beginTime) = RACObserve(_dateVM, unixTime);
    RAC(self.eventModel,coverURLStr) = RACObserve(_coverVM, coverURLString);
    RAC(self.eventModel,cycleType) = RACObserve(_cycleVM, cycleType);
    RAC(self.eventModel,tagModel) = RACObserve(_tagVM, currentTag);
    RAC(self.eventModel,isPush) = RACObserve(_pushVM, isEnablePush);
}


#pragma mark - getter&setter
- (NSArray *)dataSource{
    return @[
             [ZHTableViewItem itemWithData:_titleVM reuserId:@"EvtEditEventTitleCell" height:60],
             [ZHTableViewItem itemWithData:_coverVM reuserId:@"EvtEditEventCoverCell" height:100],
             [ZHTableViewItem itemWithData:_dateVM reuserId:@"EvtEditEventDateCell" height:60],
             [ZHTableViewItem itemWithData:_cycleVM reuserId:@"EvtEditEventCycleCell" height:60],
             [ZHTableViewItem itemWithData:_tagVM reuserId:@"EvtEditEventTagCell" height:60],
             [ZHTableViewItem itemWithData:_remarkVM reuserId:@"EvtEditEventRemarkCell" height:60],
             [ZHTableViewItem itemWithData:_pushVM reuserId:@"EvtEditEventPushCell" height:60]
             ];
}
- (RACCommand *)saveCommand{
    if (!_saveCommand) {
        @weakify(self);
        _saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                
                [[EvtEventStore shared] saveEvent:self.eventModel done:^(BOOL succeed, NSError *error) {
                    self.error = error;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                
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
                [[EvtEventStore shared] deleteWithObjectId:self.eventModel.objectId eventId:self.eventModel.eventId done:^(BOOL succeed, NSError *error) {
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
- (RACSubject *)uploadPhotoSubject{
    if (!_uploadPhotoSubject) {
        _uploadPhotoSubject = [RACSubject new];
    }
    return _uploadPhotoSubject;
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
@end
