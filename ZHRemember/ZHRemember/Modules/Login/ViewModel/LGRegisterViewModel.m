//
//  LGRegisterViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/23.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "LGRegisterViewModel.h"
#import <SMS_SDK/SMSSDK.h>
#import "ZHAccountApi.h"

@interface LGRegisterViewModel()

/** 是否可以注册*/
@property (nonatomic, strong)   RACSignal     *registEnableSignal;
/** 验证码倒计时秒数*/
@property (nonatomic, assign)   NSInteger      countDownNum;
@property (nonatomic, strong)   NSError     *error;

@end

@implementation LGRegisterViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup{
    self.countDownNum = 0;
    self.zoneCode = ChinaZoneCode;
    
    @weakify(self)
    [RACObserve(self, countDownNum) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x integerValue] > 0) {
            self.smsBtnDesc = [NSString stringWithFormat:@"%@s后重试",x];
        }else{
            self.smsBtnDesc = @"获取验证码";
        }
    }];
    [[RACObserve(self, zoneCode) filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.zoneCodeDesc = [NSString stringWithFormat:@"+ %@",x];
    }];
}
#pragma mark - request
- (void)registerAccountActionWithHandler:(void(^)(BOOL result))doneHandler{
    //验证短信
    @weakify(self);
    [SMSSDK commitVerificationCode:self.smsCode phoneNumber:self.mobilePhone zone:self.zoneCode result:^(NSError *error) {
        @strongify(self)
        if (error) {
            doneHandler(NO);
            self.error = [error zh_localized];
        }else{
            [ZHAccountApi registerWithAccount:self.mobilePhone password:self.password done:^(BOOL success, NSError *error) {
                doneHandler(success);
                self.error = [error zh_localized];
            }];
        }
    }];
}

#pragma mark - utils
- (void)getRegisterSmsCode{
    __weak typeof(self)weakself = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.mobilePhone zone:self.zoneCode template:nil result:^(NSError *error) {
        weakself.error = error;
    }];
}
- (void)startSmsCountDown{
    __block NSInteger timeout= 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownNum = timeout;
            });
        }else{
            NSInteger seconds = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownNum = seconds;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark- getter
- (RACCommand *)smsCommand{
    if (!_smsCommand) {
        @weakify(self)
        _smsCommand = [[RACCommand alloc] initWithEnabled:[RACObserve(self, countDownNum) map:^id _Nullable(id  _Nullable value) {
            //倒计时期间不可点击
            return @([value integerValue] < 1);
        }] signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self)
                [self getRegisterSmsCode];
                [self startSmsCountDown];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
                return nil;
            }];
        }];
    }
    return _smsCommand;
}
- (RACSignal *)registEnableSignal{
    if (!_registEnableSignal) {
        _registEnableSignal = [[RACSignal combineLatest:@[
                                                         RACObserve(self, mobilePhone),
                                                         RACObserve(self, password) ,
                                                         RACObserve(self, smsCode)
                                                         ]] map:^id _Nullable(RACTuple * _Nullable value) {
            RACTupleUnpack(NSString *mobile,NSString *pwd,NSString *smsCode) = value;
            return @(mobile.length > 0 && pwd.length > 6 && smsCode.length > 0);
        }];
    }
    return _registEnableSignal;
}
- (RACCommand *)registCommad{
    if (!_registCommad) {
        @weakify(self)
        _registCommad = [[RACCommand alloc] initWithEnabled:self.registEnableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                @strongify(self)
                [self registerAccountActionWithHandler:^(BOOL result) {
                    [subscriber sendNext:@(result)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _registCommad;
}
@end
