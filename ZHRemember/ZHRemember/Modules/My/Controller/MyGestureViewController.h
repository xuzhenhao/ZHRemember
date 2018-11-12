//
//  MyGestureViewController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GestureControllerTypeSetting = 1,//设置密码
    GestureControllerTypeLogin,//登录
    GestureControllerTypeVerify,//验证手势
} GestureControllerType;

NS_ASSUME_NONNULL_BEGIN

/**
 手势解锁
 */
@interface MyGestureViewController : UIViewController

/**
 *  控制器类型
 */
@property (nonatomic, assign) GestureControllerType type;
+ (instancetype)gestureViewControllerWithType:(GestureControllerType)type;

@property (nonatomic, copy) void(^settingCallback)(BOOL result,NSString *pwd);
@property (nonatomic, copy) void(^verifyCallback)(BOOL result);

@end

NS_ASSUME_NONNULL_END
