//
//  ZHAccessManager.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHAccessManager : NSObject
+ (void)getPushAccess:(void(^)(BOOL isAccess,NSString *message))done;


@end
