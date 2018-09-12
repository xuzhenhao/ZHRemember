//
//  MyThemeColorViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/28.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyThemeColorViewController.h"
#import "MyModuleHeader.h"
#import "MyThemeColorEventCell.h"
#import "MyCustomColorViewController.h"
#import "MyThemeColorViewModel.h"

static CGFloat colorViewWidth = 50;

@interface MyThemeColorViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 选择的颜色*/
@property (nonatomic, strong)   UIColor      *selectedColor;
/**供预览的按钮*/
@property (nonatomic, strong)   UIButton     *addEventButton;
/** 选择颜色滚动视图*/
@property (nonatomic, strong)   UIScrollView     *scrollView;
/** 保存按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *saveItem;
/** 自定义颜色按钮*/
@property (nonatomic, strong)   UIButton     *customColorBtn;
/** 可选择的颜色*/
@property (nonatomic, strong)   NSArray<UIColor *>     *colors;

@property (nonatomic, strong)   MyThemeColorViewModel     *viewModel;

@end

@implementation MyThemeColorViewController
+ (instancetype)themeColorViewController{
    return [self viewControllerWithStoryBoard:MyModuleStoryboard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    self.selectedColor = [UIColor zh_themeColor];
    
    [self.view addSubview:self.addEventButton];
    
    [self setupScrollView];
    self.navigationItem.rightBarButtonItem = self.saveItem;
    self.tableView.rowHeight = 370;
    
    @weakify(self)
    [[[RACObserve(self, selectedColor) skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
        self.addEventButton.backgroundColor = self.selectedColor;
        self.addEventButton.layer.shadowColor = self.selectedColor.CGColor;
        self.saveItem.enabled = YES;
    }];
    [[self.viewModel.unlockCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"已解锁"];
            [ZHGlobalStore sharedInstance].currentUser.isEnableCustomColor = YES;
        }else{
            [HBHUDManager showMessage:@"网络出错，请稍后重试"];
        }
    }];
}
- (void)setupScrollView{
    [self.view addSubview:self.scrollView];
    
    CGFloat xPos = 12;
    CGFloat margin = 10;
    for (UIColor *color in self.colors) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xPos, 0, colorViewWidth, colorViewWidth)];
        view.layer.cornerRadius = colorViewWidth/ 2;
        view.layer.masksToBounds = YES;
        view.backgroundColor = color;
        UITapGestureRecognizer *selectTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectView:)];
        [view addGestureRecognizer:selectTap];
        
        [self.scrollView addSubview:view];
        xPos += (margin+colorViewWidth);
    }
    //加上自定义颜色按钮
    [self.scrollView addSubview:self.customColorBtn];
    self.customColorBtn.ZH_x = xPos;
    xPos += (margin+colorViewWidth);
    
    self.scrollView.contentSize = CGSizeMake(xPos, colorViewWidth);
}
#pragma mark - acton
- (void)didSelectView:(UITapGestureRecognizer *)sender{
    self.selectedColor = sender.view.backgroundColor;
}
- (void)didClickSaveItem:(UIBarButtonItem *)sender{
    [ZHGlobalStore cacheThemeColor:self.selectedColor];
    [HBHUDManager showMessage:@"保存成功，重启后生效哦~"];
}
- (void)didClickCustomColorButton:(UIButton *)sender{
    BOOL isEnable = [ZHGlobalStore sharedInstance].currentUser.isEnableCustomColor;
    if (!isEnable) {
        [self alertBuyItemTipView];
        return;
    }
    
    MyCustomColorViewController *vc = [MyCustomColorViewController viewController];
    __weak typeof(self)weakself = self;
    vc.selectColorCallback = ^(UIColor *color) {
        weakself.selectedColor = color;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)alertBuyItemTipView{
    NSString *msg = [NSString stringWithFormat:@"%zd记忆水晶即可解锁调色盘，自由定制主题色哦~",IAPCustomColorPrice];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger currentMoney = [[ZHGlobalStore sharedInstance].money integerValue];
        
        if (currentMoney < IAPCustomColorPrice) {
            [HBHUDManager showMessage:@"结晶不够哦,可前往账户获取免费结晶"];
            return;
        }
        
        NSString *updateMoney = [NSString stringWithFormat:@"%zd",(currentMoney - IAPCustomColorPrice)];
        [[ZHGlobalStore sharedInstance] updateUserMoney:updateMoney];
        [self.viewModel.unlockCommand execute:updateMoney];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyThemeColorEventCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyThemeColorEventCell reuseIdentify] forIndexPath:indexPath];
    [cell updateWithColor:self.selectedColor];
    return cell;
}

#pragma mark - getter
- (MyThemeColorViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MyThemeColorViewModel new];
    }
    return _viewModel;
}
- (UIButton *)addEventButton{
    if (_addEventButton == nil) {
        _addEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addEventButton setImage:[UIImage imageNamed:@"event-write-pen"] forState:UIControlStateNormal];
        _addEventButton.frame = CGRectMake(ZHScreenWidth - 60, 420, 50, 50);
        
        _addEventButton.userInteractionEnabled = NO;
        _addEventButton.backgroundColor = self.selectedColor;
        _addEventButton.layer.cornerRadius = 25;
        _addEventButton.layer.shadowOffset = CGSizeMake(0, 8);
        _addEventButton.layer.shadowOpacity = 0.5;
        _addEventButton.layer.shadowColor = self.selectedColor.CGColor;
        _addEventButton.layer.shadowRadius = 12;
    }
    return _addEventButton;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.frame = CGRectMake(0, self.view.bounds.size.height - ZHNavbarHeight -  colorViewWidth - 20, ZHScreenWidth, colorViewWidth);
    }
    return _scrollView;
}
- (UIBarButtonItem *)saveItem{
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(didClickSaveItem:)];
        _saveItem.enabled = NO;
    }
    return _saveItem;
}
- (UIButton *)customColorBtn{
    if (!_customColorBtn) {
        _customColorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customColorBtn.frame = CGRectMake(0, 0, colorViewWidth, colorViewWidth);
        [_customColorBtn setTitle:@"自定义" forState:UIControlStateNormal];
        [_customColorBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_customColorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_customColorBtn setBackgroundColor:[UIColor blackColor]];
        _customColorBtn.layer.cornerRadius = colorViewWidth/ 2;
        _customColorBtn.layer.masksToBounds = YES;
        [_customColorBtn addTarget:self action:@selector(didClickCustomColorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customColorBtn;
}
- (NSArray<UIColor *> *)colors{
    if (!_colors) {
        _colors = @[
                    [UIColor zh_lightBlueColor],
                    [UIColor zh_lightGreenColor],
                    [UIColor zh_pinkColor],
                    [UIColor zh_yellowColor],
                    [UIColor purpleColor],
                    ];
    }
    return _colors;
}
@end
