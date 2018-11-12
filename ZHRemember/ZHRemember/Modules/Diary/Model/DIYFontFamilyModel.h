//
//  DIYFontFamilyModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DIYFontFamilyModel : NSObject

/** 是否锁住*/
@property (nonatomic, assign)   BOOL      isLock;
/** 字体名*/
@property (nonatomic, copy)     NSString    *fontName;
/** 字体价格*/
@property (nonatomic, copy)     NSString    *price;

+ (instancetype)modelWithName:(NSString *)fontName
                        price:(NSString *)price
                       isLock:(BOOL)isLock;
@end

NS_ASSUME_NONNULL_END
