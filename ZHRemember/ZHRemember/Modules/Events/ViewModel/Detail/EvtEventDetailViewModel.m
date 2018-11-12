//
//  EvtEventDetailViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventDetailViewModel.h"
#import "EvtEventApi.h"

@implementation EvtEventDetailViewModel



#pragma mark - getter
- (RACCommand *)deleteCommand{
    if (!_deleteCommand) {
        _deleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                
                return nil;
            }];
        }];
    }
    return _deleteCommand;
}

@end
