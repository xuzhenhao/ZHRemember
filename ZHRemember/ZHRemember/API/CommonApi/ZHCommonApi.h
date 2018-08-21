//
//  ZHCommonApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHCommonApi : NSObject

+ (void)uploadImage:(UIImage *)image
               done:(void(^)(NSString *urlString,NSDictionary *error))doneHandler;
@end
