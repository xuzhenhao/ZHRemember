//
//  EvtEventListController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListController.h"
#import "EvtEventHeader.h"
#import "EvtEditEventController.h"
#import "EvtEventListViewModel.h"

@interface EvtEventListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)   EvtEventListViewModel     *viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 添加事件按钮*/
@property (nonatomic, strong)   UIButton     *addEventButton;

@end

@implementation EvtEventListController

+ (instancetype)eventListController{
   return [self viewControllerWithStoryBoard:EvtEventStoryboard];
}
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self bindActions];
}
#pragma mark - UI
- (void)initialSetup{
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.addEventButton];
    [self setupTableView];
}
- (void)setupTableView{
    @weakify(self)
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.viewModel.loadDataCommand execute:nil];
    }];
//    header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = header;
    [header beginRefreshing];
}
- (void)bindActions{
    @weakify(self)
    [[self.viewModel.loadDataCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:EvtEditEventSuccessNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.viewModel.loadDataCommand execute:nil];
    }];
}
#pragma mark - action
- (void)didClickAddEventButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    [self navigateToEditViewControllerWithModel:nil];
}
- (void)navigateToEditViewControllerWithModel:(EvtEventModel *)model{
    EvtEditEventController *editVC = [EvtEditEventController editEventControllerWithModel:model];
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel SectionCount];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel rowCountForSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuserId = [self.viewModel reuserIdForSection:indexPath.section row:indexPath.row];
    id viewModel = [self.viewModel viewModelForSection:indexPath.section row:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId forIndexPath:indexPath];
    [cell bindViewModel:viewModel];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel rowHeightForSection:indexPath.section row:indexPath.row];
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self navigateToEditViewControllerWithModel:[self.viewModel modelForSection:indexPath.section row:indexPath.row]];
}

#pragma mark - getter
- (EvtEventListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [EvtEventListViewModel new];
    }
    return _viewModel;
}
- (UIButton *)addEventButton{
    if (_addEventButton == nil) {
        _addEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addEventButton.frame = CGRectMake(ZHScreenWidth - 60, ZHScreenHeight - 250, 50, 50);
        _addEventButton.layer.cornerRadius = 25;
        _addEventButton.backgroundColor = [UIColor greenColor];
        [_addEventButton addTarget:self action:@selector(didClickAddEventButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addEventButton;
}

@end
