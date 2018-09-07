//
//  MyThemeColorViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyThemeColorViewModel.h"
#import "ZHAccountApi.h"

NSInteger IAPCustomColorPrice = 100;

@implementation MyThemeColorViewModel


#pragma mark - getter
- (RACCommand *)unlockCommand{
    if (!_unlockCommand) {
        _unlockCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [ZHAccountApi unlockCustomThemeWithObjectId:[ZHCache sharedInstance].currentUser.objectId money:input done:^(BOOL isSuccess, NSError *error) {
                    [subscriber sendNext:@(isSuccess)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _unlockCommand;
}
@end
