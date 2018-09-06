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
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "ZHCache.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource,GADRewardBasedVideoAdDelegate,GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   MyViewModel     *viewModel;
/** <#desc#>*/
@property (nonatomic, strong)   GADBannerView     *bannerView;

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
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"d2d8d83c04a65e1143980cd07639b4fc" ];
    [self.bannerView loadRequest:request];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
//            [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
//        }
//    });
}
- (void)setupObserver{
    
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
        default:
            break;
    }
}
- (void)navigateToIAP{
    UIViewController *diamondVC = [[ZHMediator sharedInstance] zh_diamondViewController];
    diamondVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:diamondVC animated:YES];
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

#pragma mark - banner adDelegate
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    self.tableView.tableHeaderView = self.bannerView;
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}
#pragma mark - video ad
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSString *rewardMessage =
    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
     reward.type,
     [reward.amount doubleValue]];
}


#pragma mark - getter
- (MyViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [MyViewModel new];
    }
    return _viewModel;
}
- (GADBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _bannerView.adUnitID = AdMobBannerId;
        
        self.bannerView.rootViewController = self;
        self.bannerView.delegate = self;
    }
    return _bannerView;
}
@end
