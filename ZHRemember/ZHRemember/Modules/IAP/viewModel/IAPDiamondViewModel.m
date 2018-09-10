//
//  IAPDiamondViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondViewModel.h"
#import "ZHAccountApi.h"

NSInteger IAPDisableAdPrice = 200;

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
    
    IAPDiamondCellViewModel *sixYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"120记忆结晶" price:@"¥ 6" eventId:IAPEventBuySixRMB];
    IAPDiamondCellViewModel *eightYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"540记忆结晶" price:@"¥ 18" eventId:IAPEventBuyEighteenRMB];
    IAPDiamondCellViewModel *threeYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"900记忆结晶" price:@"¥ 30" eventId:IAPEventBuythirtyRMB];
    self.viewModels = @[sixYuanModel,eightYuanModel,threeYuanModel];
    
    IAPDiamondCellViewModel *signModel = [IAPDiamondCellViewModel viewModelWithTitle:@"签到(每日+2)" price:@"签到" eventId:IAPEventSign];
    IAPDiamondCellViewModel *publishModel = [IAPDiamondCellViewModel viewModelWithTitle:@"发表日记(每日+5)" price:@"前往" eventId:IAPEventPublish];
    IAPDiamondCellViewModel *adModel = [IAPDiamondCellViewModel viewModelWithTitle:@"看广告(每次+5)" price:@"前往" eventId:IAPEventWatchAds];
    self.freeViewModels = @[signModel,publishModel,adModel];
}
- (NSString *)getRewardMoneyForAction:(NSString *)action{
    //原本的钱
    NSInteger currentMoney = [[ZHCache sharedInstance].money integerValue];
    NSInteger rewardMoney = 0;
    if ([action isEqualToString:IAPEventBuySixRMB]) {
        rewardMoney = 120;
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
    
    return [NSString stringWithFormat:@"%zd",(currentMoney + rewardMoney)];
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
                
                NSString *nowTime = [[NSDate date] formattedDateWithFormat:@"MM-dd" locale:[NSLocale systemLocale]];
                [ZHAccountApi updateUserSignTimeWithObjectId:[ZHCache sharedInstance].currentUser.objectId signTime:nowTime done:^(BOOL isSuccess, NSError *error) {
                    [subscriber sendNext:@(isSuccess)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _signCommand;
}
- (RACCommand *)updateMoneyCommand{
    if (!_updateMoneyCommand) {
        _updateMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if (!input) {
                    [subscriber sendNext:@(NO)];
                    [subscriber sendCompleted];
                    return nil;
                }
                
                [ZHAccountApi updateUserMoney:input objectId:[ZHCache sharedInstance].currentUser.objectId done:^(BOOL isSuccess, NSError *error) {
                    [subscriber sendNext:@(isSuccess)];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
        }];
    }
    return _updateMoneyCommand;
}
- (RACCommand *)disableAdCommand{
    if (!_disableAdCommand) {
        _disableAdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [ZHAccountApi updateUserDisalbeAdWithObjectId:[ZHCache sharedInstance].currentUser.objectId money:input done:^(BOOL isSuccess, NSError *error) {
                    [subscriber sendNext:@(isSuccess)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _disableAdCommand;
}
@end
