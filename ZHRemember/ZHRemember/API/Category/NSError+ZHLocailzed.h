//
//  NSError+ZHLocailzed.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/17.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ZHLocailzed)

/**
 根据错误码添加本地化错误提示信息

 @param code 错误码
 */
- (NSError *)zh_localized;

@end
