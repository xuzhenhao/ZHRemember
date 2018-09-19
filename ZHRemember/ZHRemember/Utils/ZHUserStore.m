//
//  ZHUserStore.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/12.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHUserStore.h"
#import "ZHAccountApi.h"
#import "ZHDBManager.h"

static NSString *ZHStoreUserCacheKey = @"ZHStoreUserCacheKey";

@interface ZHUserStore()

@property (nonatomic, strong)   ZHUserModel     *currentUser;
@property (nonatomic, copy)     NSString    *userObjectId;
@property (nonatomic, copy)     NSString    *money;
@property (nonatomic, assign)   BOOL      isSigned;
@property (nonatomic, assign)   BOOL      isPublished;

@end

@implementation ZHUserStore

+ (instancetype)shared{
    static ZHUserStore *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.isSigned = NO;
        manager.isPublished = NO;
        manager.money = @"0";
    });
    return manager;
}
- (void)loadUser{
    //加载本地用户数据
    ZHUserModel *user = [[ZHDBManager manager] objectForKey:ZHStoreUserCacheKey atTable:ZHStoreUserCacheKey].lastObject;
    if (user) {
        [self updateUser:user];
    }
    
    //加载网络数据
    __weak typeof(self)weakself = self;
    [ZHAccountApi getUserInfoWithDoneHandler:^(ZHUserModel *user, NSError *error) {
        if (error || !user) {
            [HBHUDManager showMessage:@"获取用户信息错误，请重新登录"];
            return ;
        }
        [weakself updateUser:user];
        //缓存到本地
        [[ZHDBManager manager] deleteAllAtTable:ZHStoreUserCacheKey];
        [[ZHDBManager manager] insertObject:user forKey:ZHStoreUserCacheKey atTable:ZHStoreUserCacheKey];
    }];
}
- (void)updateUser:(ZHUserModel *)user{
    self.currentUser = user;
    if (!self.isSigned || !self.isPublished) {
        [self _checkIfSigned];
    }
    
    if ([user.money integerValue] > 0) {
        self.money = user.money;
    }
}
- (void)addMoney:(NSInteger)money
            done:(void(^)(BOOL success,NSError *error))done{
    //本地更新
    [self _addMoney:money];
    
    __weak typeof(self)weakself = self;
    [ZHAccountApi updateUserMoney:self.money objectId:self.userObjectId done:^(BOOL isSuccess, NSError *error) {
        if (error) {
            [weakself _addMoney:-money];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}

- (void)setUserHaveSignedWithReward:(NSInteger)reward
                               done:(void(^)(BOOL success,NSError *error))done{
    [self _addMoney:reward];
    self.isSigned = YES;
    
    NSString *now = [[NSDate date] formattedDateWithFormat:@"MM-dd" locale:[NSLocale systemLocale]];
    
    __weak typeof(self)weakself = self;
    [ZHAccountApi updateUserSignTimeWithObjectId:self.userObjectId money:self.money signTime:now done:^(BOOL isSuccess, NSError *error) {
        if (error) {
            weakself.isSigned = NO;
            [weakself _addMoney:-reward];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
- (void)setUserHavePublishedWithReward:(NSInteger)reward
                                  done:(void(^)(BOOL success,NSError *error))done{
    [self _addMoney:reward];
    self.isPublished = YES;
    
    NSString *now = [[NSDate date] formattedDateWithFormat:@"MM-dd" locale:[NSLocale systemLocale]];
    __weak typeof(self)weakself = self;
    [ZHAccountApi updateUserPublishRewardWithObjectId:self.userObjectId money:self.money publishTime:now done:^(BOOL isSuccess, NSError *error) {
        if (error) {
            weakself.isPublished = NO;
            [weakself _addMoney:-reward];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
- (void)enableAdBlockWithCost:(NSInteger)cost
                         done:(void(^)(BOOL success,NSError *error))done{
    [self _addMoney:-cost];
    
    __weak typeof(self)weakself = self;
    [ZHAccountApi updateUserDisalbeAdWithObjectId:self.userObjectId money:self.money done:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            weakself.currentUser.isDisableAd = YES;
        }else{
            [weakself _addMoney:cost];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
- (void)enableCustomColorWithCost:(NSInteger)cost
                             done:(void(^)(BOOL success,NSError *error))done{
    [self _addMoney:-cost];
    
    __weak typeof(self)weakself = self;
    [ZHAccountApi unlockCustomThemeWithObjectId:self.userObjectId money:self.money done:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            weakself.currentUser.isEnableCustomColor = YES;
        }else{
            [weakself _addMoney:cost];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
- (void)enableCustomLettersWithCost:(NSInteger)cost
                               done:(void(^)(BOOL success,NSError *error))done{
    [self _addMoney:-cost];

    __weak typeof(self)weakself = self;
    [ZHAccountApi unlockLetterWithObjectId:self.userObjectId money:self.money done:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            weakself.currentUser.isUnlockLetter = YES;
        }else{
            [weakself _addMoney:cost];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
- (void)enableCustomFont:(NSString *)font
                    cost:(NSInteger)cost
                    done:(void(^)(BOOL success,NSError *error))done{

    ZHCustomFontType fontType = 0;
    if ([font isEqualToString:FontSnP2]) {
        fontType = ZHCustomFontSn;
    }else if ([font isEqualToString:FontJianyayi]){
        fontType = ZHCustomFontJYY;
    }else if ([font isEqualToString:FontHuaKangShaoNv]){
        fontType = ZHCustomFontGirl;
    }else if ([font isEqualToString:FontLoliCat]){
        fontType = ZHCustomFontCat;
    }else{
        done(NO,nil);
    }
    [self _addMoney:-cost];
    
    __weak typeof(self)weakself = self;
    [ZHAccountApi unlockFontWithObjectId:self.userObjectId fontName:fontType money:self.money done:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            switch (fontType) {
                case ZHCustomFontCat:
                    weakself.currentUser.isUnlockCatFont = YES;
                    break;
                case ZHCustomFontGirl:
                    weakself.currentUser.isUnlockGirlFont = YES;
                    break;
                case ZHCustomFontJYY:
                    weakself.currentUser.isUnlockJYYFont = YES;
                    break;
                case ZHCustomFontSn:
                    weakself.currentUser.isUnlockSnFont = YES;
                    break;
            }
        }else{
            [weakself _addMoney:cost];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
- (void)enableCustomFontColorWithCost:(NSInteger)cost
                                 done:(void(^)(BOOL success,NSError *error))done{
    [self _addMoney:-cost];
    __weak typeof(self)weakself = self;
    [ZHAccountApi unlockFontColorWithObjectId:self.userObjectId money:self.money done:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            weakself.currentUser.isUnlockFontColor = YES;
        }else{
            [weakself _addMoney:cost];
            [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
        }
        done(isSuccess,error);
    }];
}
#pragma mark - private method
- (void)_addMoney:(NSInteger)money{
    NSInteger currentMoney = [self.money integerValue];
    currentMoney += money;
    self.money = [NSString stringWithFormat:@"%zd",currentMoney];
    self.currentUser.money = self.money;
}
- (void)_checkIfSigned{
    NSString *now = [[NSDate date] formattedDateWithFormat:@"MM-dd" locale:[NSLocale systemLocale]];
    if ([self.currentUser.signTime isEqualToString:now]) {
        self.isSigned = YES;
    }
    if ([self.currentUser.publishTime isEqualToString:now]) {
        self.isPublished = YES;
    }
}

#pragma mark - getter
- (NSString *)userObjectId{
    return self.currentUser.objectId;
}
@end
