//
//  MyThemeColorViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
/**自定义颜色项目价格*/
extern NSInteger IAPCustomColorPrice;

@interface MyThemeColorViewModel : NSObject

/** 解锁自定义主题,需传入更新后的钱数*/
@property (nonatomic, strong)   RACCommand     *unlockCommand;

@end
