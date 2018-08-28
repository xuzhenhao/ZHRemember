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
}

- (void)setupUI{
    self.title = @"设置";
    self.tableView.rowHeight = [self.viewModel itemHeight];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfItemsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:[MySettingCell reuseIdentify] forIndexPath:indexPath];
    [cell bindViewModel:[self.viewModel viewModelForRow:indexPath.row section:indexPath.section]];
    
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
        default:
            break;
    }
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
#pragma mark - getter
- (MyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MyViewModel new];
    }
    return _viewModel;
}

@end
