//
//  DIYWriteDiaryViewController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHDiaryModel;

extern NSString *DIYDiaryChangedNotification;

/**写日记*/
@interface DIYWriteDiaryViewController : UIViewController

+ (instancetype)writeDiaryViewController;
+ (instancetype)writeDiaryViewControllerWithModel:(ZHDiaryModel *)model;

@end
