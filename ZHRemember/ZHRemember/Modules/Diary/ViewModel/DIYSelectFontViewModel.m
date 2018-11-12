//
//  DIYSelectFontViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectFontViewModel.h"
#import "ZHUserStore.h"

@interface DIYSelectFontViewModel ()

@property (nonatomic, strong)   NSArray<DIYFontFamilyModel *>     *fonts;
@property (nonatomic, strong)   NSArray<DIYFontColorModel *>     *colors;

@end

@implementation DIYSelectFontViewModel

- (instancetype)init{
    if (self = [super init]) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup{
    [self setupFontFamily];
    [self setupFontSize];
}
- (void)setupFontSize{
    DIYFontColorModel *blackModel = [DIYFontColorModel modelWithColor:@"#000000" isLock:NO];
    DIYFontColorModel *blueModel = [DIYFontColorModel modelWithColor:@"#33CCF5" isLock:NO];
    DIYFontColorModel *greenModel = [DIYFontColorModel modelWithColor:@"#33D6BB" isLock:NO];
    DIYFontColorModel *pinkModel = [DIYFontColorModel modelWithColor:@"#F95A7D" isLock:NO];
    DIYFontColorModel *yellowModel = [DIYFontColorModel modelWithColor:@"#F9D86A" isLock:NO];
    DIYFontColorModel *purpleModel = [DIYFontColorModel modelWithColor:@"#800080" isLock:NO];
    
    BOOL isColorLock = !([ZHUserStore shared].currentUser.isUnlockFontColor);
    DIYFontColorModel *customModel = [DIYFontColorModel modelWithColor:@"#800080" isLock:isColorLock];
    customModel.isCustomSelect = YES;
    self.colors = @[blackModel,blueModel,greenModel,pinkModel,yellowModel,purpleModel,customModel];
}
- (void)setupFontFamily{
    DIYFontFamilyModel *modelPF = [DIYFontFamilyModel modelWithName:FontPingFangRegaular price:@"0" isLock:NO];
    DIYFontFamilyModel *modelPFM = [DIYFontFamilyModel modelWithName:FontPingFangMedium price:@"0" isLock:NO];
    DIYFontFamilyModel *modelPFT = [DIYFontFamilyModel modelWithName:FontPingFangThin price:@"0" isLock:NO];
    DIYFontFamilyModel *modelK = [DIYFontFamilyModel modelWithName:FontGB2312 price:@"0" isLock:NO];
    
    ZHUserModel *user = [ZHUserStore shared].currentUser;
    
    DIYFontFamilyModel *modelSn = [DIYFontFamilyModel modelWithName:FontSnP2 price:@"60" isLock:!user.isUnlockSnFont];
    DIYFontFamilyModel *modelJyy = [DIYFontFamilyModel modelWithName:FontJianyayi price:@"60" isLock:!user.isUnlockJYYFont];
    DIYFontFamilyModel *modelGirl = [DIYFontFamilyModel modelWithName:FontHuaKangShaoNv price:@"60" isLock:!user.isUnlockGirlFont];
    DIYFontFamilyModel *modelCat = [DIYFontFamilyModel modelWithName:FontLoliCat price:@"60" isLock:!user.isUnlockCatFont];
    self.fonts = @[modelPF,modelPFM,modelPFT,modelK,modelSn,modelJyy,modelGirl,modelCat];
    
}
#pragma mark - TableView
- (NSInteger)numberOfRows{
    return self.fonts.count;
}
- (DIYFontFamilyModel *)modelOfRow:(NSInteger)row{
    if (row >= self.fonts.count) {
        return nil;
    }
    return self.fonts[row];
}
#pragma mark - CollectionView
- (NSInteger)numberOfItems{
    return self.colors.count;
}
- (DIYFontColorModel *)modelOfItem:(NSInteger)item{
    if (item >= self.colors.count) {
        return nil;
    }
    return self.colors[item];
}
#pragma mark - getter
- (RACCommand *)unlockFontCommand{
    if (!_unlockFontCommand) {
        _unlockFontCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[ZHUserStore shared] enableCustomFont:input cost:IAPUnlockFontPrice done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _unlockFontCommand;
}
- (RACCommand *)unlockColorCommand{
    if (!_unlockColorCommand) {
        _unlockColorCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [[ZHUserStore shared] enableCustomFontColorWithCost:IAPUnlockFontColorPrice done:^(BOOL success, NSError *error) {
                    [subscriber sendNext:@(success)];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _unlockColorCommand;
}
@end
