//
//  DIYFontColorCell.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/18.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DIYFontColorModel;

/**
 选择字体颜色cell
 */
@interface DIYFontColorCell : UICollectionViewCell

/** 字体颜色模型*/
@property (nonatomic, strong)   DIYFontColorModel     *colorModel;

@end
