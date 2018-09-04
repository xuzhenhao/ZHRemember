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
    
    IAPDiamondCellViewModel *sixYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"180(120送60)" price:@"¥ 6" goodsId:@"xzh.remember6"];
    IAPDiamondCellViewModel *eightYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"540(360送180)" price:@"¥ 18" goodsId:@"xzh.remember18"];
    IAPDiamondCellViewModel *threeYuanModel = [IAPDiamondCellViewModel viewModelWithTitle:@"900(600送300)" price:@"¥ 30" goodsId:@"xzh.remember30"];
    self.viewModels = @[sixYuanModel,eightYuanModel,threeYuanModel];
}

- (void)addDiamondWithNumber:(NSInteger)number{
    self.diamondNum += number;
    self.diamondString = [NSString stringWithFormat:@"%zd",self.diamondNum];
}
- (NSInteger)numberOfrows{
    return self.viewModels.count;
}
- (CGFloat)rowHeight{
    return 90;
}
- (IAPDiamondCellViewModel *)viewModelOfIndexPath:(NSIndexPath *)path{
    if (path.row >= self.viewModels.count) {
        return nil;
    }
    return self.viewModels[path.row];
}

#pragma mark - getter
@end
