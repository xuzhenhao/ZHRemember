//
//  IAPDiamondViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondViewModel.h"
#import "ZHUserStore.h"

NSInteger IAPDisableAdPrice = 300;

@interface IAPDiamondViewModel()
@property (nonatomic, strong)   NSArray<IAPDiamondCellViewModel *>     *viewModels;
@property (nonatomic, strong)   NSArray<IAPDiamondCellViewModel *>     *freeViewModels;

@end

@implementation IAPDiamondViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)initConfig{
    
//    IAPDiamondCellViewModel *sixYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"180记忆结晶" price:@"¥ 6" eventId:IAPEventBuySixRMB];
//    IAPDiamondCellViewModel *eightYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"540记忆结晶" price:@"¥ 18" eventId:IAPEventBuyEighteenRMB];
//    IAPDiamondCellViewModel *threeYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"900记忆结晶" price:@"¥ 30" eventId:IAPEventBuythirtyRMB];
//    self.viewModels = @[sixYuanModel,eightYuanModel,threeYuanModel];
    
    IAPDiamondCellViewModel *signModel = [IAPDiamondCellViewModel viewModelWithTitle:@"签到(每日+2)" price:@"签到" eventId:IAPEventSign];
    IAPDiamondCellViewModel *publishModel = [IAPDiamondCellViewModel viewModelWithTitle:@"发表日记(每日+5)" price:@"前往" eventId:IAPEventPublish];
//    IAPDiamondCellViewModel *adModel = [IAPDiamondCellViewModel viewModelWithTitle:@"看广告(每次+5)" price:@"前往" eventId:IAPEventWatchAds];
    self.freeViewModels = @[signModel,publishModel];
}
- (NSString *)getRewardMoneyForAction:(NSString *)action{
    NSInteger rewardMoney = 0;
    if ([action isEqualToString:IAPEventBuySixRMB]) {
        rewardMoney = 180;
    }else if ([action isEqualToString:IAPEventBuyEighteenRMB]){
        rewardMoney = 540;
    }else if ([action isEqualToString:IAPEventBuythirtyRMB]){
        rewardMoney = 900;
    }else if ([action isEqualToString:IAPEventSign]){
        rewardMoney = 2;
    }else if ([action isEqualToString:IAPEventPublish]){
        rewardMoney = 5;
    }else if ([action isEqualToString:IAPEventWatchAds]){
        rewardMoney = 5;
    }
    
    return [NSString stringWithFormat:@"%ld",rewardMoney];
}
#pragma mark- tableView
- (NSInteger)numberOfSection{
    return 2;
}
- (NSInteger)numberOfrowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.viewModels.count;
            break;
        case 1:
            return self.freeViewModels.count;
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)rowHeight{
    return 65;
}
- (IAPDiamondCellViewModel *)viewModelOfIndexPath:(NSIndexPath *)path{
    
    if (path.section == 0) {
        return self.viewModels[path.row];
    }
    return self.freeViewModels[path.row];
    
}

#pragma mark - getter
- (RACCommand *)signCommand{
    if (!_signCommand) {
        _signCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[ZHUserStore shared] setUserHaveSignedWithReward:2 done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _signCommand;
}
- (RACCommand *)addMoneyCommand{
    if (!_addMoneyCommand) {
        _addMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[ZHUserStore shared] addMoney:[input integerValue] done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _addMoneyCommand;
}
- (RACCommand *)disableAdCommand{
    if (!_disableAdCommand) {
        _disableAdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                [[ZHUserStore shared] enableAdBlockWithCost:IAPDisableAdPrice done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _disableAdCommand;
}
@end
