//
//  EvtEditEventSetTopViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 置顶VM
 */
@interface EvtEditEventSetTopViewModel : NSObject
/** 是否置顶*/
@property (nonatomic, assign)   BOOL      isTop;

+ (instancetype)viewModelWithTop:(BOOL)isTop;

@end
