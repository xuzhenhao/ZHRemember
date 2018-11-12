//
//  ZHVersionApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHVersionApi : NSObject

/**
 获取最新的版本信息

 @param done version:版本号，versionDesc:版本描述
 */
+ (void)getLatestVersionWithDoneHandler:(void (^)(NSString * versionNum,NSString *versionDesc))done;

@end
