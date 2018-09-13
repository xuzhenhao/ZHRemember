//
//  DIYDiaryListViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryListViewController.h"
#import "DIYWriteDiaryViewController.h"
#import "DIYDiaryConfig.h"
#import "DIYDiaryListViewModel.h"
#import "DIYDiaryListCell.h"

@interface DIYDiaryListViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 写日记按钮*/
@property (nonatomic, strong)   UIButton     *writeDiaryButton;

@property (nonatomic, strong)   DIYDiaryListViewModel     *viewModel;
@end

@implementation DIYDiaryListViewController
+ (instancetype)diaryListViewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindActions];
    [self setupNotification];
}
#pragma mark - setupUI
- (void)setupUI{
    self.title = @"日记本";
    
    [self.view addSubview:self.writeDiaryButton];
    
    @weakify(self)
    [self.tableView configHeadRefreshControlWithRefreshBlock:^{
        @strongify(self)
        [self.viewModel.requestCommand execute:nil];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)bindActions{
    
    @weakify(self)
    [[self.viewModel.requestCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        self.tableView.emptyDataSetSource = self;
        [self.tableView reloadData];
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:DIYDiaryChangedNotification object:nil] deliverOnMainThread] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header beginRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numOfRows];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DIYDiaryListCell *cell = [tableView dequeueReusableCellWithIdentifier:[DIYDiaryListCell reuseIdentify] forIndexPath:indexPath];
    [cell bindViewModel:[self.viewModel viewModelOfRow:indexPath.row section:indexPath.section]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel heightOfRow:indexPath.row section:indexPath.section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZHDiaryModel *model = [self.viewModel viewModelOfRow:indexPath.row section:indexPath.section].model;
    [self naviageToWriteDiaryViewControllerWithModel:model];
}

#pragma mark - action
- (void)didClickWriteDiaryButton:(UIButton *)sender{
    [self naviageToWriteDiaryViewControllerWithModel:nil];
}
- (void)naviageToWriteDiaryViewControllerWithModel:(ZHDiaryModel *)model{
    DIYWriteDiaryViewController *writeVC = nil;
    if (!model) {
       writeVC = [DIYWriteDiaryViewController writeDiaryViewController];
    }else{
        writeVC = [DIYWriteDiaryViewController writeDiaryViewControllerWithModel:model];
    }
    writeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:writeVC animated:YES];
}
#pragma mark - DZNEmptyDataSetSource

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:@""];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:@"即刻用文字留住当下时光"];
}
#pragma mark - notification
- (void)setupNotification{
    @weakify(self)
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:themeColorChangedNotification object:nil]
       takeUntil:self.rac_willDeallocSignal]
      deliverOnMainThread]
     subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self)
         self.writeDiaryButton.backgroundColor = [UIColor zh_themeColor];
         self.writeDiaryButton.layer.shadowColor = [UIColor zh_themeColor].CGColor;
     }];
}

#pragma mark - getter
- (UIButton *)writeDiaryButton{
    if (_writeDiaryButton == nil) {
        _writeDiaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeDiaryButton setImage:[UIImage imageNamed:@"event-write-pen"] forState:UIControlStateNormal];
        _writeDiaryButton.frame = CGRectMake(ZHScreenWidth - 60, ZHScreenHeight - 250, 50, 50);
        
        _writeDiaryButton.backgroundColor = [UIColor zh_themeColor];
        _writeDiaryButton.layer.cornerRadius = 25;
        _writeDiaryButton.layer.shadowOffset = CGSizeMake(0, 8);
        _writeDiaryButton.layer.shadowOpacity = 0.5;
        _writeDiaryButton.layer.shadowColor = [UIColor zh_themeColor].CGColor;
        _writeDiaryButton.layer.shadowRadius = 12;
        
        [_writeDiaryButton addTarget:self action:@selector(didClickWriteDiaryButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeDiaryButton;
}
- (DIYDiaryListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [DIYDiaryListViewModel new];
    }
    return _viewModel;
}


@end
