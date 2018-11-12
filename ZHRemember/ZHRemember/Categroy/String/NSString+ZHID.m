//
//  NSString+ZHID.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/13.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "NSString+ZHID.h"

@implementation NSString (ZHID)
+ (NSString*)zh_onlyID{
    
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    NSString *uniqueId = (__bridge NSString *)(uuidStringRef);
    
    return uniqueId;
    
}

@end
