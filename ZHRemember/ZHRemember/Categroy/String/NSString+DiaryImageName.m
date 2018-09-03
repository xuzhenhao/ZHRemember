//
//  NSString+DiaryImageName.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/3.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "NSString+DiaryImageName.h"

@implementation NSString (DiaryImageName)

+ (NSString *)diary_weatherImageNameOfIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"diary-weather%zd",index];
}

+ (NSString *)diary_moodImageNameOfIndex:(NSInteger)index{
    return [NSString stringWithFormat:@"diary-mood%zd",index];
}

@end
