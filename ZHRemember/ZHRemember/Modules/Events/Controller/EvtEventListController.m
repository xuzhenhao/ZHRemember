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
#import "EvtEventDetailController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface EvtEventListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,GADBannerViewDelegate>

@property (nonatomic, strong)   EvtEventListViewModel     *viewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 添加事件按钮*/
@property (nonatomic, strong)   UIButton     *addEventButton;

@property (nonatomic, strong)   GADBannerView     *bannerView;

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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([ZHCache sharedInstance].currentUser.isDisableAd) {
        self.tableView.tableHeaderView = nil;
    }
}
#pragma mark - UI
- (void)initialSetup{
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.addEventButton];
    
    @weakify(self)
    [self.tableView configHeadRefreshControlWithRefreshBlock:^{
        @strongify(self)
        [self.viewModel.loadDataCommand execute:nil];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    if (!([ZHCache sharedInstance].currentUser.isDisableAd)) {
        [self setupAdBanner];
    }
}
- (void)setupAdBanner{
    GADRequest *request = [GADRequest request];
    if (![ZHCache isProductEnvironment]) {
        request.testDevices = @[ @"d2d8d83c04a65e1143980cd07639b4fc" ];
    }
    [self.bannerView loadRequest:request];
    
}
- (void)bindActions{
    @weakify(self)
    [[self.viewModel.loadDataCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        self.tableView.emptyDataSetSource = self;
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
- (void)navigateToDetailViewControllerWithModel:(EvtEventModel *)model{
    EvtEventDetailController *detailVC = [EvtEventDetailController detailViewControlleWithEvent:model];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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

#pragma mark - DZNEmptyDataSetSource

- (nullable NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:@"欢迎使用~"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc] initWithString:@"试着写下自己的第一个纪念日吧!"];
}
#pragma mark - banner adDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.contentOffset = CGPointMake(0, self.bannerView.ZH_height);
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
        [_addEventButton setImage:[UIImage imageNamed:@"event-write-pen"] forState:UIControlStateNormal];
        _addEventButton.frame = CGRectMake(ZHScreenWidth - 60, ZHScreenHeight - 250, 50, 50);
        
        _addEventButton.backgroundColor = [UIColor zh_themeColor];
        _addEventButton.layer.cornerRadius = 25;
        _addEventButton.layer.shadowOffset = CGSizeMake(0, 8);
        _addEventButton.layer.shadowOpacity = 0.5;
        _addEventButton.layer.shadowColor = [UIColor zh_themeColor].CGColor;
        _addEventButton.layer.shadowRadius = 12;
        
        [_addEventButton addTarget:self action:@selector(didClickAddEventButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addEventButton;
}
- (GADBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _bannerView.adUnitID = [ZHCache isProductEnvironment] ? AdMobBannerId : AdMobBannerTestId;
        
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
    }
    return _bannerView;
}

@end
