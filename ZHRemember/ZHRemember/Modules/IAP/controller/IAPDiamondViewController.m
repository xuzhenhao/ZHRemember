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

@interface IAPDiamondViewController ()<UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;

@property (nonatomic, strong)   IAPDiamondViewModel     *viewModel;

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
    self.title = @"记忆结晶";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
- (void)bindAction{
    @weakify(self)
    [[[RACObserve(self.viewModel, diamondString) deliverOnMainThread] filter:^BOOL(id  _Nullable value) {
        return value && [value integerValue] >= 0;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.diamondLabel.text = x;
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfrows];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IAPDiamondCell *cell = [tableView dequeueReusableCellWithIdentifier:[IAPDiamondCell reuseIdentify] forIndexPath:indexPath];
    IAPDiamondCellViewModel *viewModel = [self.viewModel viewModelOfIndexPath:indexPath];
    [cell bindViewModel:viewModel];
    
    __weak typeof(self)weakself = self;
    cell.didClickBuyCallback = ^(NSString *goodsId) {
        [weakself processBuyActionWithGoodsId:goodsId];
    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
#pragma mark - action
- (void)processBuyActionWithGoodsId:(NSString *)goodsId{
    //如果app允许applepay
    if ([SKPaymentQueue canMakePayments]) {
        // 请求苹果后台商品
        [self getRequestAppleProductWithGoodsId:goodsId];
    }
    else
    {
        [HBHUDManager showMessage:@"您的程序没有打开付费购买"];
    }
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
    
    SKProduct *requestProduct = product.lastObject;
    
    SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
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
                [self verifyPurchaseWithPaymentTransactionWith:tran];
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
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */
-(void)verifyPurchaseWithPaymentTransactionWith:(SKPaymentTransaction *)tran{
    
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString  *receiptString = [receiptData base64EncodedStringWithOptions:0];
    
    if (!receiptString) {
        return;
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:tran];

    [HBHUDManager showMessage:@"购买成功" done:^{
        [self.viewModel addDiamondWithNumber:120];
    }];
}

//结束后一定要销毁
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
-(NSString * )environmentForReceipt:(NSString * )str
{
    str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSArray * arr=[str componentsSeparatedByString:@";"];
    
    //存储收据环境的变量
    NSString * environment=arr[2];
    return environment;
}
#pragma mark - getter
- (IAPDiamondViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [IAPDiamondViewModel new];
    }
    return _viewModel;
}

@end
