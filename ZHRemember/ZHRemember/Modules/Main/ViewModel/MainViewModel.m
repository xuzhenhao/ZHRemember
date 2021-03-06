//
//  MainViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/6.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MainViewModel.h"
#import <UMAnalytics/MobClick.h>

@implementation MainViewModel
- (void)AnalyticsUserStart{
    [MobClick profileSignInWithPUID:[ZHUserStore shared].currentUser.userId];
}
#pragma mark - getter
- (RACCommand *)syncUserCommand{
    if (!_syncUserCommand) {
        _syncUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[ZHUserStore shared] loadUser];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _syncUserCommand;
}

@end
