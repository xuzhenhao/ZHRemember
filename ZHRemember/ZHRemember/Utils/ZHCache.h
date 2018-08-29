//
//  ZHCache.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/29.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 缓存业务数据，对外屏蔽存储是具体实现(NSUserDefaults,FMDB等)
 */
@interface ZHCache : NSObject

/**
 缓存用户选择的主题色

 @param themeColor 主题色
 */
+ (void)cacheThemeColor:(UIColor *)themeColor;

/**
 获取用户的主题色
 */
+ (UIColor *)getThemeColor;

@end
