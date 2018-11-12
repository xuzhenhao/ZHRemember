//
//  DIYFontColorModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/18.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIYFontColorModel : NSObject
/** 是否锁住*/
@property (nonatomic, assign)   BOOL      isLock;
/** 是否自定义颜色*/
@property (nonatomic, assign)   BOOL      isCustomSelect;
/** 颜色*/
//@property (nonatomic, strong)   UIColor     *color;
@property (nonatomic, copy)     NSString    *hexColor;


+ (instancetype)modelWithColor:(NSString *)color isLock:(BOOL)isLock;

@end
