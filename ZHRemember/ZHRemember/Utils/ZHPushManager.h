//
//  ZHPushManager.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 推送服务
 */
@interface ZHPushManager : NSObject

/**
 添加一项本地推送(如有同名的，则修改)

 @param name 推送名称，唯一标识
 @param date 推送时间
 @param type 重复类型
 @param msg 提示语
 */
+ (void)addLocalPushWithName:(NSString *)name date:(NSDate *)date shouldRepead:(BOOL)shouldRepeat repeat:(NSCalendarUnit)type message:(NSString *)msg;
@end
