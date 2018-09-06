//
//  IAPDiamondViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/4.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPDiamondCellViewModel.h"

@interface IAPDiamondViewModel : NSObject
/** 余额*/
@property (nonatomic, copy)     NSString    *diamondString;


/**增加记忆结晶*/
- (void)addDiamondWithNumber:(NSInteger)number;

- (NSInteger)numberOfSection;
- (NSInteger)numberOfrowsInSection:(NSInteger)section;
- (CGFloat)rowHeight;
- (IAPDiamondCellViewModel *)viewModelOfIndexPath:(NSIndexPath *)path;

@end
