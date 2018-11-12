//
//  MyViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyViewController.h"
#import "MyModuleHeader.h"
#import "MyViewModel.h"
#import "MySettingCell.h"
#import "MyThemeColorViewController.h"
#import "LCUserFeedbackAgent.h"
#import "ZHGlobalStore.h"
#import "MyGestureViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   MyViewModel     *viewModel;

@end

@implementation MyViewController
+ (instancetype)myViewController{
    return [self viewControllerWithStoryBoard:MyModuleStoryboard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupObserver];
}

- (void)setupUI{
    self.title = @"设置";
    self.tableView.rowHeight = [self.viewModel itemHeight];
}
- (void)setupObserver{
    @weakify(self)
    [[self.viewModel.refreshSubject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfItemsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MySettingViewModel *vm = [self.viewModel viewModelForRow:indexPath.row section:indexPath.section];
    
    MySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:vm.reuserId forIndexPath:indexPath];
    [cell bindViewModel:vm];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self navigateWithIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 9.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor zh_lightGrayColor];
    
    return view;
}

#pragma mark - deal action
- (void)navigateWithIndexPath:(NSIndexPath *)indexPath{
    MySettingType type = [self.viewModel itemTypeOfRow:indexPath.row section:indexPath.section];
    switch (type) {
        case MySettingTypeLogout:
            [self logout];
            break;
        case MySettingTypeTag:
            [self navigateToTagManager];
            break;
        case MySettingTypeThemeColor:
            [self navigateToThemeColorViewController];
            break;
        case MySettingTypeFeedback:
            [self navigateToFeedback];
            break;
        case MySettingTypeAccount:
            [self navigateToIAP];
            break;
        case MySettingTypeGesture:
            [self gesturePwdAction];
            break;
        default:
            break;
    }
}
- (void)navigateToIAP{
#ifdef Pro
//    [HBHUDManager showMessage:@"更多功能，敬请期待"];
#else
    UIViewController *diamondVC = [[ZHMediator sharedInstance] zh_diamondViewController];
    diamondVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:diamondVC animated:YES];
#endif
}
- (void)navigateToFeedback{
    LCUserFeedbackAgent *agent = [LCUserFeedbackAgent sharedInstance];
    
    [agent showConversations:self title:@"意见反馈" contact:nil];
}
- (void)navigateToThemeColorViewController{
    UIViewController *themeVC = [MyThemeColorViewController themeColorViewController];
    themeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:themeVC animated:YES];
}
- (void)navigateToTagManager{
    UIViewController *tagViewController = [[ZHMediator sharedInstance] eventTagController];
    tagViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tagViewController animated:YES];
}
- (void)logout{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否退出当前登录账号?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel logout];
        [UIViewController changeRootToRegisterViewController];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)gesturePwdAction{
    if (![ZHGlobalStore isGestureExist]) {
        [self navigateToSetupGesturePassword];
        return;
    }
    
    __weak typeof(self)weakself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"手势解锁" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MyGestureViewController *vc = [MyGestureViewController gestureViewControllerWithType:GestureControllerTypeVerify];
        vc.verifyCallback = ^(BOOL result) {
            if (result) {
                [weakself navigateToSetupGesturePassword];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"停用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MyGestureViewController *vc = [MyGestureViewController gestureViewControllerWithType:GestureControllerTypeVerify];
        vc.verifyCallback = ^(BOOL result) {
            if (result) {
                [ZHGlobalStore saveGesturePassword:nil];
                [HBHUDManager showMessage:@"已停用"];
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)navigateToSetupGesturePassword{
    MyGestureViewController *vc = [MyGestureViewController gestureViewControllerWithType:GestureControllerTypeSetting];
    vc.settingCallback = ^(BOOL result, NSString * _Nonnull pwd) {
        if (result) {
            [ZHGlobalStore saveGesturePassword:pwd];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - getter
- (MyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MyViewModel new];
    }
    return _viewModel;
}
@end
