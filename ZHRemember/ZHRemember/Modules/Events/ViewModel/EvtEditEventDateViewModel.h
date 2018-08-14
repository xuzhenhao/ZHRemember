//
//  EvtEditEventDateViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvtEditEventDateViewModel : NSObject

@property (nonatomic, strong)   NSDateComponents     *dateComp;
/** 格式化后的时间*/
@property (nonatomic, copy)     NSString    *dateFormat;


+ (instancetype)viewModelWithDate:(NSString *)dateString;

/** <#desc#>*/
@property (nonatomic, strong)   RACSubject     *selectDateSubject;

@end
