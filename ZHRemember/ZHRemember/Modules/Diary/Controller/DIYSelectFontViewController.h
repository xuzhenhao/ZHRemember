//
//  DIYSelectFontViewController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/17.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选择写日记字体页面
 */
@interface DIYSelectFontViewController : UIViewController

///** 字体名*/
//@property (nonatomic, copy,readonly)     NSString    *fontName;
///** 字体大小*/
//@property (nonatomic, assign,readonly)   NSInteger      fontSize;
///** 字体颜色*/

/** 字体改变回调*/
@property (nonatomic, strong)   RACSubject     *fontNameSubject;
/** 字体大小改变回调*/
@property (nonatomic, strong)   RACSubject     *fontSizeSubject;
/** <#desc#>*/
@property (nonatomic, strong)   RACSubject     *fontColorSubject;

+ (instancetype)fontViewController;

@end
