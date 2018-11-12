//
//  ZHCommonApi.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHCommonApi.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation ZHCommonApi

+ (void)uploadImage:(UIImage *)image
               done:(void(^)(NSString *urlString,NSDictionary *error))doneHandler{
    AVFile *file = [AVFile fileWithData:UIImagePNGRepresentation(image)];
    [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        doneHandler(file.url,@{@"msg":error.userInfo ?: @{}});
    }];
}
@end
