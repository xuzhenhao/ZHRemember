//
//  IAPDiamondViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondViewController.h"
#import "IAPConfig.h"
#import "IAPDiamondCell.h"
#import "IAPDiamondViewModel.h"
#import <StoreKit/StoreKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface IAPDiamondViewController ()<UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,GADRewardBasedVideoAdDelegate>
/**用户当前余额*/
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
/** 去广告按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *adItem;

@property (nonatomic, strong)   IAPDiamondViewModel     *viewModel;
/** 当前正在购买商品的id*/
@property (nonatomic, copy)     NSString    *currentGoodsId;

@end

@implementation IAPDiamondViewController

+ (instancetype)diamondViewController{
    return [self viewControllerWithStoryBoard:IAPModuleStoryboardName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindAction];
}
- (void)setupUI{
    self.title = @"我的账户";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    self.navigationItem.rightBarButtonItem = self.adItem;
}
- (void)bindAction{
    @weakify(self)
    [[[RACObserve([ZHCache sharedInstance], money) deliverOnMainThread] filter:^BOOL(id  _Nullable value) {
        return value && [value integerValue] >= 0;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.diamondLabel.text = x;
    }];
    
    [[self.viewModel.signCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"签到成功"];
            NSString *money = [self.viewModel getRewardMoneyForAction:IAPEventSign];
            [[ZHCache sharedInstance] updateUserMoney:money];
            [[ZHCache sharedInstance] setUserSigned];
            [self.viewModel.updateMoneyCommand execute:money];
        }
    }];

    [[self.viewModel.disableAdCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"已为您去除广告"];
            [ZHCache sharedInstance].currentUser.isDisableAd = YES;
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSection];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfrowsInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IAPDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:[IAPDiamondCell reuseIdentify] forIndexPath:indexPath];
    IAPDiamondCellViewModel *viewModel = [self.viewModel viewModelOfIndexPath:indexPath];
    [cell bindViewModel:viewModel];
    
    __weak typeof(self)weakself = self;
    cell.didClickBuyCallback = ^(NSString *eventId) {
        [weakself processBuyActionWithEventId:eventId];
    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    [view addSubview:titleLabel];
    titleLabel.text = section == 0 ? @"充值" : @"免费获取";
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - action
- (void)processBuyActionWithEventId:(NSString *)eventId{
    if ([eventId isEqualToString:IAPEventWatchAds]) {
        //看广告
        [self watchVideoAdsEvent];
    }else if ([eventId isEqualToString:IAPEventPublish]){
        //写日记
    }else if([eventId isEqualToString:IAPEventSign]){
        //签到
        if ([ZHCache sharedInstance].isSigned) {
            [HBHUDManager showMessage:@"今日已签到"];
        }else{
            [self.viewModel.signCommand execute:nil];
        }
    }else{
        if ([SKPaymentQueue canMakePayments]) {
            // 请求苹果后台商品
            self.currentGoodsId = eventId;
            [self getRequestAppleProductWithGoodsId:eventId];
        }
        else
        {
            [HBHUDManager showMessage:@"您的程序没有打开付费购买"];
        }
    }
}
- (void)finishBuyingEvent{
    NSString *money = [self.viewModel getRewardMoneyForAction:self.currentGoodsId];
    //本地先更新了
    [[ZHCache sharedInstance] updateUserMoney:money];
    [self.viewModel.updateMoneyCommand execute:money];
}
- (void)watchVideoAdsEvent{
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }else{
        [HBHUDManager showMessage:@"暂无广告，请稍后重试"];
        [self loadNextMovieAds];
    }
}
- (void)finishWatchAdsEvent{
    NSString *money = [self.viewModel getRewardMoneyForAction:IAPEventWatchAds];
    //本地先更新了
    [[ZHCache sharedInstance] updateUserMoney:money];
    [self.viewModel.updateMoneyCommand execute:money];
    [HBHUDManager showMessage:@"感谢支持，您已获得奖励"];
}
- (void)loadNextMovieAds{
    NSString *UnitId = [ZHCache isProductEnvironment] ? AdMobMovieId : AdMobMovieTestId;
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:
     [GADRequest request] withAdUnitID:UnitId];
}
- (void)didClickDisableItem:(UIBarButtonItem *)sender{
    NSString *msg = [NSString stringWithFormat:@"您确定要花费%zd记忆结晶购买去广告项目?",IAPDisableAdPrice];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger currentMoney = [[ZHCache sharedInstance].money integerValue];
        if ([ZHCache sharedInstance].currentUser.isDisableAd) {
            [HBHUDManager showMessage:@"您已去除过广告，无需重复购买"];
            return;
        }
        if (currentMoney < IAPDisableAdPrice) {
            [HBHUDManager showMessage:@"结晶不够哦~"];
            return;
        }
        
        NSString *updateMoney = [NSString stringWithFormat:@"%zd",(currentMoney - IAPDisableAdPrice)];
        [[ZHCache sharedInstance] updateUserMoney:updateMoney];
        [self.viewModel.disableAdCommand execute:updateMoney];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - request
- (void)getRequestAppleProductWithGoodsId:(NSString *)goodsId
{
    NSArray *product = [[NSArray alloc] initWithObjects:goodsId,nil];
    NSSet *nsset = [NSSet setWithArray:product];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    
    //如果服务器没有产品
    if([product count] == 0){
        [HBHUDManager showMessage:@"连接appstore失败"];
        return;
    }
    SKProduct *requestProduct = nil;
    for (SKProduct *pro in product) {
        if([pro.productIdentifier isEqualToString:self.currentGoodsId]){
            requestProduct = pro;
        }
    }

    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
    //发送购买请求
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [HBHUDManager showMessage:@"连接appstore失败"];
}
#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self finishBuyingEvent];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                break;
        }
    }
}
#pragma mark - video ad
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    [self finishWatchAdsEvent];
}
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    //请求下一个广告
    [self loadNextMovieAds];
}

//结束后一定要销毁
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark - getter
- (IAPDiamondViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [IAPDiamondViewModel new];
    }
    return _viewModel;
}
- (UIBarButtonItem *)adItem{
    if (!_adItem) {
        _adItem = [[UIBarButtonItem alloc] initWithTitle:@"去广告" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDisableItem:)];
    }
    return _adItem;
}
@end



/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
//-(void)verifyPurchaseWithPaymentTransactionWith:(SKPaymentTransaction *)tran{
//
//    //从沙盒中获取交易凭证并且拼接成请求体数据
//    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
//    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
//
//    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
//
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
//    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
//
//
//    //创建请求到苹果官方进行购买验证
//    NSURL *url=[NSURL URLWithString:IAPSandboxURL];
//    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
//    requestM.HTTPBody=bodyData;
//    requestM.HTTPMethod=@"POST";
//    //创建连接并发送同步请求
//    NSError *error=nil;
//    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
//
//    if (error) {
//        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
//        return;
//    }
//    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//    if([dic[@"status"] intValue] == 0){
//        NSLog(@"购买成功！");
//
//        NSDictionary *dicReceipt= dic[@"receipt"];
//        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
//        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
//        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//        //在此处对购买记录进行存储，可以存储到开发商的服务器端
//    }else{
//        NSLog(@"购买失败，未通过验证！");
//    }
//}
