//
//  MyThemeColorViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyThemeColorViewModel.h"
#import "ZHUserStore.h"

NSInteger IAPCustomColorPrice = 100;

@implementation MyThemeColorViewModel


#pragma mark - getter
- (RACCommand *)unlockCommand{
    if (!_unlockCommand) {
        _unlockCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[ZHUserStore shared] enableCustomColorWithCost:IAPCustomColorPrice done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _unlockCommand;
}
@end
