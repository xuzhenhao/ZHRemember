//
//  DIYSelectFontViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/17.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectFontViewController.h"
#import "DIYDiaryConfig.h"
#import "DIYFontColorCell.h"
#import "DIYFontFamilyCell.h"
#import "DIYSelectFontViewModel.h"
#import "MyCustomColorViewController.h"

@interface DIYSelectFontViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)   DIYSelectFontViewModel     *viewModel;

@end

@implementation DIYSelectFontViewController
+ (instancetype)fontViewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupObserver];
}
#pragma mark - setupUI
- (void)setupUI{
    self.tableView.rowHeight = 44;
}
- (CGSize)preferredContentSize{
    return CGSizeMake(ZHScreenWidth, 220);
}
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
- (void)setupObserver{
    @weakify(self)
    [[self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [[[self.fontSizeSlider rac_signalForControlEvents:UIControlEventValueChanged] deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSInteger size = ((UISlider *)x).value;
        [self.fontSizeSubject sendNext:@(size)];
    }];
}
#pragma mark - UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfRows];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DIYFontFamilyCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIYFontFamilyCell reuseIdentify] forIndexPath:indexPath];
    DIYFontFamilyModel *model = [self.viewModel modelOfRow:indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DIYFontFamilyModel *model = [self.viewModel modelOfRow:indexPath.row];
    //判断购买逻辑
    if (model.isLock) {
        [self showBuyFontTipMessageWithFont:model];
        return;
    }
    [self.viewModel.fontNameSubject sendNext:model.fontName];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.viewModel numberOfItems];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DIYFontColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DIYFontColorCell" forIndexPath:indexPath];
    DIYFontColorModel *model = [self.viewModel modelOfItem:indexPath.item];
    cell.colorModel = model;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DIYFontColorModel *model = [self.viewModel modelOfItem:indexPath.item];
    if (model.isLock) {
        [self showBuyFontColorTipMessageWithFontColor:model];
    }else if (model.isCustomSelect){
        [self navigateToCustomColorPage];
    }
    else{
        [self.fontColorSubject sendNext:model.hexColor];
    }
    
}

#pragma mark - util
- (void)showBuyFontTipMessageWithFont:(DIYFontFamilyModel *)font{
    NSString *msg = [NSString stringWithFormat:@"您确定要花费%ld记忆结晶购买该字体?",IAPUnlockFontPrice];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger currentMoney = [[ZHUserStore shared].money integerValue];
        
        if (currentMoney < IAPUnlockFontPrice) {
            [HBHUDManager showMessage:@"结晶不够哦~"];
            return;
        }
        
        @weakify(self)
        [[[self.viewModel.unlockFontCommand execute:font.fontName] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            BOOL success = [x boolValue];
            if (success) {
                [HBHUDManager showMessage:@"已解锁"];
                font.isLock = NO;
                @strongify(self)
                [self.tableView reloadData];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)showBuyFontColorTipMessageWithFontColor:(DIYFontColorModel *)fontColor{
    __weak typeof(self)weakself = self;
    
    NSString *msg = [NSString stringWithFormat:@"是否花费%ld记忆结晶解锁自定义字体颜色?",IAPUnlockFontColorPrice];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger currentMoney = [[ZHUserStore shared].money integerValue];
        
        if (currentMoney < IAPUnlockFontColorPrice) {
            [HBHUDManager showMessage:@"结晶不够哦~"];
            return;
        }
        
        @weakify(self)
        [[[self.viewModel.unlockColorCommand execute:nil] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            BOOL success = [x boolValue];
            if (success) {
                [HBHUDManager showMessage:@"已解锁"];
                fontColor.isLock = NO;
                @strongify(self)
                [self.collectionView reloadData];
            }
        }];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)navigateToCustomColorPage{
    MyCustomColorViewController *colorVc = [MyCustomColorViewController viewController];
    
    __weak typeof(self)weakself = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:colorVc] animated:YES completion:nil];
    colorVc.selectColorCallback = ^(UIColor *color) {
        
        NSString *hexString = [color zh_hexString];
        [weakself.fontColorSubject sendNext:hexString];
    };
}
#pragma mark - getter
- (DIYSelectFontViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [DIYSelectFontViewModel new];
        _viewModel.fontNameSubject = self.fontNameSubject;
    }
    return _viewModel;
}
- (RACSubject *)fontNameSubject{
    if (!_fontNameSubject) {
        _fontNameSubject = [RACSubject new];
    }
    return _fontNameSubject;
}
- (RACSubject *)fontSizeSubject{
    if (!_fontSizeSubject) {
        _fontSizeSubject = [RACSubject new];
    }
    return _fontSizeSubject;
}
- (RACSubject *)fontColorSubject{
    if (!_fontColorSubject) {
        _fontColorSubject = [RACSubject new];
    }
    return _fontColorSubject;
}

@end
