//
//  EvtEditEventViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventViewModel.h"
#import "ZHTableViewItem.h"
#import "EvtEventApi.h"

@interface EvtEditEventViewModel()
/** 用于封装网络请求的数据*/
@property (nonatomic, strong)   EvtEventModel     *eventModel;

@end

@implementation EvtEditEventViewModel
+ (instancetype)viewModelWithModel:(EvtEventModel *)model{
    EvtEditEventViewModel *vm = [EvtEditEventViewModel new];
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
    @weakify(self);
    _saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //网络请求保存数据
            @strongify(self)
            [EvtEventApi saveEvent:self.eventModel done:^(BOOL success, NSDictionary *result) {
                if (success) {
                    [subscriber sendNext:@(YES)];
                }
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
}


#pragma mark - getter&setter
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

@end