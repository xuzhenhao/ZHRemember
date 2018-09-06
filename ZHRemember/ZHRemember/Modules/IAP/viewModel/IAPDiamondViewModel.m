//
//  IAPDiamondViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "IAPDiamondViewModel.h"

@interface IAPDiamondViewModel()
@property (nonatomic, strong)   NSArray<IAPDiamondCellViewModel *>     *viewModels;
@property (nonatomic, strong)   NSArray<IAPDiamondCellViewModel *>     *freeViewModels;
/** <#desc#>*/
@property (nonatomic, assign)   NSInteger      diamondNum;

@end

@implementation IAPDiamondViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}
- (void)initConfig{
    self.diamondNum = 0;
    
    IAPDiamondCellViewModel *sixYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"120记忆结晶" price:@"¥ 6" eventId:IAPEventBuySixRMB];
    IAPDiamondCellViewModel *eightYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"540记忆结晶" price:@"¥ 18" eventId:IAPEventBuyEighteenRMB];
    IAPDiamondCellViewModel *threeYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"900记忆结晶" price:@"¥ 30" eventId:IAPEventBuythirtyRMB];
    self.viewModels = @[sixYuanModel,eightYuanModel,threeYuanModel];
    
    IAPDiamondCellViewModel *signModel = [IAPDiamondCellViewModel viewModelWithTitle:@"签到(每日+2)" price:@"签到" eventId:IAPEventSign];
    IAPDiamondCellViewModel *publishModel = [IAPDiamondCellViewModel viewModelWithTitle:@"发表日记(每日+5)" price:@"前往" eventId:IAPEventPublish];
    IAPDiamondCellViewModel *adModel = [IAPDiamondCellViewModel viewModelWithTitle:@"看广告(每次+5)" price:@"前往" eventId:IAPEventWatchAds];
    self.freeViewModels = @[signModel,publishModel,adModel];
}

- (void)addDiamondWithNumber:(NSInteger)number{
    self.diamondNum += number;
    self.diamondString = [NSString stringWithFormat:@"%zd",self.diamondNum];
}
- (NSInteger)numberOfSection{
    return 2;
}
- (NSInteger)numberOfrowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.viewModels.count;
            break;
        case 1:
            return self.freeViewModels.count;
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)rowHeight{
    return 90;
}
- (IAPDiamondCellViewModel *)viewModelOfIndexPath:(NSIndexPath *)path{
    
    if (path.section == 0) {
        return self.viewModels[path.row];
    }
    return self.freeViewModels[path.row];
    
}

#pragma mark - getter
@end
