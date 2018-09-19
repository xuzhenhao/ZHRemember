//
//  DIYFontFamilyModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYFontFamilyModel.h"

@implementation DIYFontFamilyModel

+ (instancetype)modelWithName:(NSString *)fontName
                        price:(NSString *)price
                       isLock:(BOOL)isLock{
    DIYFontFamilyModel *model = [DIYFontFamilyModel new];
    model.isLock = isLock;
    model.fontName = fontName;
    model.price = price;
    
    return model;
}

@end
