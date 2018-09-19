//
//  DIYFontFamilyCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DIYFontFamilyModel;

NS_ASSUME_NONNULL_BEGIN


/**
 选择字体样式cell
 */
@interface DIYFontFamilyCell : UITableViewCell

/** 字体样式模型*/
@property (nonatomic, strong)   DIYFontFamilyModel     *model;

@end

NS_ASSUME_NONNULL_END
