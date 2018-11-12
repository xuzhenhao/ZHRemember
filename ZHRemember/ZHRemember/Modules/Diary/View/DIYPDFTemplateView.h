//
//  DIYPDFTemplateView.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHDiaryModel;

/**
 生成pdf模板View
 */
@interface DIYPDFTemplateView : UIView

+ (instancetype)templateViewWithModel:(ZHDiaryModel *)model;

@end
