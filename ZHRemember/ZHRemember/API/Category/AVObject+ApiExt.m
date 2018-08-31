//
//  AVObject+ApiExt.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AVObject+ApiExt.h"

NSString *const AVUserIdKey = @"user_id";
NSString *const AVObjectIdKey = @"objectId";

@implementation AVObject (ApiExt)
- (NSDictionary *)zh_localData{
    return [self valueForKey:@"localData"];
}


@end
