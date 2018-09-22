//
//  ZHIAPConfig.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/22.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *IAPSandboxURL;//沙盒测试环境验证
extern NSString *IAPAppstoreURL;//正式环境验证
#pragma mark - price
extern NSInteger IAPUnlockLetterPirce;//解锁信纸费用
extern NSInteger IAPUnlockFontPrice;//解锁自定义字体费用
extern NSInteger IAPUnlockFontColorPrice;//解锁自定义字体颜色
#pragma mark - reward
extern NSInteger PublishDiaryReward;//发布日记奖励

NS_ASSUME_NONNULL_BEGIN

/**
 内购相关设置
 */
@interface ZHIAPConfig : NSObject

@end

NS_ASSUME_NONNULL_END
