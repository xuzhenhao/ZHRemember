//
//  ZHPDFCreater.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHPDFCreater : NSObject

+ (BOOL)createPDFWithImages:(NSArray<UIImage *>*)images
                   fileName:(NSString *)fileName
                   pageSize:(CGSize)size;

+ (NSString *)filePathWithName:(NSString *)name;

@end
