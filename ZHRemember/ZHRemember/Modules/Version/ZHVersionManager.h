//
//  ZHVersionManager.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHVersionManager : NSObject

/**
 *  获取版本管理工具实例
 */
+ (instancetype)sharedManager;

- (void)checkUpdateVersionWithDoneHandler:(void (^)(BOOL isNewVersion,NSString *versionDesc))done;

@end
