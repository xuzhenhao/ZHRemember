//
//  MainViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/6.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MainViewModel.h"
#import "ZHAccountApi.h"

@implementation MainViewModel


- (void)_cacheUser:(ZHUserModel *)user{
    if (!user) {
        return;
    }
    [[ZHCache sharedInstance] updateUser:user];
}
#pragma mark - getter
- (RACCommand *)syncUserCommand{
    if (!_syncUserCommand) {
        @weakify(self)
        _syncUserCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [ZHAccountApi getUserInfoWithDoneHandler:^(ZHUserModel *user, NSError *error) {
                    @strongify(self)
                    [self _cacheUser:user];
                }];
                return nil;
            }];
        }];
    }
    return _syncUserCommand;
}

@end
