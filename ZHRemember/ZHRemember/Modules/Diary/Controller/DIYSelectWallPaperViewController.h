//
//  DIYSelectWallPaperViewController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选择信纸页
 */
@interface DIYSelectWallPaperViewController : UIViewController

+ (instancetype)paperViewController;
@property (nonatomic, copy) void(^selectPaperCallback)(NSString *imageName);

@end
