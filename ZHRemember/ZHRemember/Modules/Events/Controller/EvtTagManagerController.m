//
//  EvtTagManagerController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtTagManagerController.h"
#import "EvtEventHeader.h"
#import "EvtTagListCell.h"
#import "EvtTagManageViewModel.h"

@interface EvtTagManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;

@property (nonatomic, strong)   EvtTagManageViewModel     *viewModel;

@end

@implementation EvtTagManagerController
+ (instancetype)tagController{
    return [self viewControllerWithStoryBoard:EvtEventStoryboard];
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupOberver];
}

#pragma mark - setup UI
- (void)setupUI{
    self.tableView.rowHeight = 60;
    
    @weakify(self)
    [self.tableView configHeadRefreshControlWithRefreshBlock:^{
        @strongify(self)
        [[[self.viewModel.requestCommand execute:nil] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            //此处是刷新动作的完成。刷新UI在监听数据源的回调中
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupOberver{
    @weakify(self)
    
    RAC(self.addTagButton,enabled) = [self.inputTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 0);
    }];
    [[self.addTagButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.view endEditing:YES];
        [self.viewModel.addCommand execute:self.inputTextField.text];
    }];
    [[self.viewModel.dataRefreshSubject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    [[self.viewModel.addCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            self.inputTextField.text = nil;
        }
    }];
    [[self.viewModel.delCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"已删除"];
        }
    }];
    [[[RACObserve(self.viewModel, error) filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        NSError *error = x;
        [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel rows];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EvtTagListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvtTagListCell" forIndexPath:indexPath];
    cell.tagModel = [self.viewModel modelOfRow:indexPath.row];
    return cell;
}
#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showEditAlertControllerForIndexPath:indexPath];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EvtTagModel *model = [self.viewModel modelOfRow:indexPath.row];
        [self.viewModel.delCommand execute:model];
    }
}

#pragma mark - action
- (void)showEditAlertControllerForIndexPath:(NSIndexPath *)indexPath{
    EvtTagModel *model = [self.viewModel modelOfRow:indexPath.row];
    
    @weakify(self)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改标签名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *txtField = alertController.textFields.firstObject;
        model.tagName = txtField.text;
        @strongify(self)
        [self.viewModel.addCommand execute:model];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = model.tagName;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - getter&setter
- (EvtTagManageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [EvtTagManageViewModel new];
    }
    return _viewModel;
}

@end
