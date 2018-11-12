//
//  LGLoginViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "LGLoginViewModel.h"
#import "ZHAccountApi.h"

@interface LGLoginViewModel()
/** 可以登录信用*/
@property (nonatomic, strong)   RACSignal     *loginEnableSignal;
@property (nonatomic, strong)   NSError     *error;

@end

@implementation LGLoginViewModel


#pragma mark - getter
- (RACCommand *)loginCommand{
    if (!_loginCommand) {
        @weakify(self)
        _loginCommand = [[RACCommand alloc] initWithEnabled:self.loginEnableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [ZHAccountApi LoginWithAccount:self.account password:self.password done:^(BOOL success, NSError *error) {
                    self.error = [error zh_localized];
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _loginCommand;
}
- (RACSignal *)loginEnableSignal{
    if (!_loginEnableSignal) {
        _loginEnableSignal = [[RACSignal combineLatest:@[
                                                          RACObserve(self, account),
                                                          RACObserve(self, password)
                                                          ]] map:^id _Nullable(RACTuple * _Nullable value) {
            RACTupleUnpack(NSString *mobile,NSString *pwd) = value;
            return @(mobile.length > 0 && pwd.length > 6);
        }];
    }
    return _loginEnableSignal;
}
@end
