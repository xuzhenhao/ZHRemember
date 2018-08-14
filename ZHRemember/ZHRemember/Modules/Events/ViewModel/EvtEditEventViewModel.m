//
//  EvtEditEventViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventViewModel.h"
#import "ZHTableViewItem.h"

@implementation EvtEditEventViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig{
    EvtEditEventTitleViewModel *titleVM = [EvtEditEventTitleViewModel viewModelWithEventName:nil];
    
    EvtEditEventCoverViewModel *coverVM = [EvtEditEventCoverViewModel viewModelWithCoverURL:nil];
    coverVM.selectPhotoSubject = self.selectPhotoSubject;
    
    EvtEditEventDateViewModel *dateVM = [EvtEditEventDateViewModel viewModelWithDate:nil];
    dateVM.selectDateSubject = self.selectDateSubject;
    
    NSArray *contents = @[
                          [ZHTableViewItem itemWithData:titleVM reuserId:@"EvtEditEventTitleCell" height:60],
                          [ZHTableViewItem itemWithData:coverVM reuserId:@"EvtEditEventCoverCell" height:100],
                          [ZHTableViewItem itemWithData:dateVM reuserId:@"EvtEditEventDateCell" height:60]
                          ];
    self.dataSource = contents;
    
    RAC(self,isSaveEnable) = [[RACSignal combineLatest:@[
                                                        RACObserve(titleVM, eventName)
                                                        ,RACObserve(dateVM, dateFormat)
                                                        ]] map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSString *eventName,NSString *dateString) = value;
        return @(eventName && dateString && eventName.length > 0 && dateString.length > 0);
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
@end
