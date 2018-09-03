//
//  DIYSelectMoodViewController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选择心情、天气
 */
@interface DIYSelectMoodViewController : UIViewController

+ (instancetype)viewController;

@property (nonatomic, copy) void(^selectMoodWeatherCallback)(NSString *moodName,NSString *weatherName,NSString *paperName);

@end
