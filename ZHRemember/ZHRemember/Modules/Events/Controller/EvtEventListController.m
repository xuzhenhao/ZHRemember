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
    [self setupView];
    [self setupObserver];
    [self setupNotification];
}
#pragma mark - UI
- (void)setupView{
    [self.view addSubview:self.addEventButton];
    //下拉刷新
    @weakify(self)
    [self.tableView configHeadRefreshControlWithRefreshBlock:^{
        @strongify(self)
        [[[self.viewModel.loadDataCommand execute:nil] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            //此处是刷新动作的完成。刷新UI在监听数据源的回调中
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupAdBanner{
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}
- (void)setupObserver{
    @weakify(self)
    [[[RACObserve([ZHUserStore shared], currentUser.isDisableAd) skip:1] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL hiddenAds = [x boolValue];
        if (hiddenAds) {
            self.tableView.tableHeaderView = nil;
        }else{
            [self setupAdBanner];
        }
    }];
    //通过监听数据源改变，自动刷新tableView。不用到处发通知
    [[[self.viewModel.dataRefreshSubject skip:0] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.tableView.emptyDataSetSource = self;
        [self.tableView reloadData];
    }];
    //监听错误码弹窗提示用户
    [[[[RACObserve(self.viewModel, error) skip:1] filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        NSError *error = x;
        [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
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
    if ([ZHUserStore shared].currentUser.isDisableAd) {
        return;
    }
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.contentOffset = CGPointMake(0, self.bannerView.ZH_height);
}
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

#pragma mark - notification
- (void)setupNotification{
    @weakify(self)
    [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:themeColorChangedNotification object:nil]
       takeUntil:self.rac_willDeallocSignal]
      deliverOnMainThread]
     subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self)
         self.addEventButton.backgroundColor = [UIColor zh_themeColor];
         self.addEventButton.layer.shadowColor = [UIColor zh_themeColor].CGColor;
         [self.tableView reloadData];
     }];
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
        _bannerView.adUnitID = [ZHGlobalStore isProductEnvironment] ? AdMobBannerId : AdMobBannerTestId;
        
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
    }
    return _bannerView;
}

@end
