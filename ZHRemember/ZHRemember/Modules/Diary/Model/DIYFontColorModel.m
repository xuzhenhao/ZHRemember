//
//  DIYFontColorModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/18.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYFontColorModel.h"

@implementation DIYFontColorModel

+ (instancetype)modelWithColor:(NSString *)color isLock:(BOOL)isLock{
    DIYFontColorModel *model = [DIYFontColorModel new];
    model.isLock = isLock;
    model.hexColor = color;
    
    return model;
}
@end
