//
//  AVObject+ApiExt.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "AVObject+ApiExt.h"

@implementation AVObject (ApiExt)
- (NSDictionary *)localData{
    return [self valueForKey:@"localData"];
}


@end
