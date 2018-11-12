//
//  DIYSelectFontViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DIYFontFamilyModel.h"
#import "DIYFontColorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DIYSelectFontViewModel : NSObject

#pragma mark - TableView
- (NSInteger)numberOfRows;
- (DIYFontFamilyModel *)modelOfRow:(NSInteger)row;

#pragma mark - CollectionView
- (NSInteger)numberOfItems;
- (DIYFontColorModel *)modelOfItem:(NSInteger)item;

@property (nonatomic, weak)   RACSubject     *fontNameSubject;
/** 解锁字体,参数为字体名*/
@property (nonatomic, strong)   RACCommand     *unlockFontCommand;
/** 解锁字体自定义颜色*/
@property (nonatomic, strong)   RACCommand     *unlockColorCommand;

@end

NS_ASSUME_NONNULL_END
