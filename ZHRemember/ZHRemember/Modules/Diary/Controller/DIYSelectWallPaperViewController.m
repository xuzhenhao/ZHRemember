//
//  DIYSelectWallPaperViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectWallPaperViewController.h"
#import "DIYDiaryConfig.h"
#import "DIYSelectWallPaperViewModel.h"
#import "DIYSelectPaperCell.h"

@interface DIYSelectWallPaperViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)   DIYSelectWallPaperViewModel     *viewModel;

@end

@implementation DIYSelectWallPaperViewController
+ (instancetype)paperViewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信纸";
    [self bindAction];
}
- (void)bindAction{
    [[self.viewModel.unlockLetterCommand.executionSignals.switchToLatest deliverOnMainThread]
      subscribeNext:^(id  _Nullable x) {
          BOOL isSuccess = [x boolValue];
          if (isSuccess) {
              [HBHUDManager showMessage:@"解锁成功"];
          }else{
              [HBHUDManager showMessage:@"交易失败，请稍后重试"];
          }
    }];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.viewModel numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.viewModel numberOfItemsInSection:section];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DIYSelectPaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DIYSelectPaperCell" forIndexPath:indexPath];
    [cell updateWithImageName:[self.viewModel imageNameOfIndex:indexPath]];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"test" forIndexPath:indexPath];
    UILabel *titleLabel = [view viewWithTag:10086];
#ifdef Pro
    titleLabel.text = @"精美信纸";
#else
    if (indexPath.section == 0) {
        titleLabel.text = @"免费信纸";
    }else{
        titleLabel.text = @"付费信纸";
    }
#endif
    
    return view;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        //判断是否已购买付费信纸
        if (![self _checkIfUnlockLetter]) {
            [self _alertBuyItemTipView];
            return;
        }
    }
    NSString *imageName = [self.viewModel imageNameOfIndex:indexPath];
    if (self.selectPaperCallback) {
        self.selectPaperCallback(imageName);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - privat method
- (BOOL)_checkIfUnlockLetter{
    return [ZHUserStore shared].currentUser.isUnlockLetter;
}
- (void)_alertBuyItemTipView{
    NSString *msg = [NSString stringWithFormat:@"%zd记忆水晶即可解锁付费信纸~",IAPUnlockLetterPirce];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger currentMoney = [[ZHUserStore shared].money integerValue];
        
        if (currentMoney < IAPUnlockLetterPirce) {
            [HBHUDManager showMessage:@"结晶不够哦,可前往账户获取免费结晶"];
            return;
        }
        
        [self.viewModel.unlockLetterCommand execute:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - getter
- (DIYSelectWallPaperViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [DIYSelectWallPaperViewModel new];
    }
    return _viewModel;
}

@end
