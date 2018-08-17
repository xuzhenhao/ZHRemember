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
/** 时间戳*/
@property (nonatomic, copy)     NSString    *unixTime;


+ (instancetype)viewModelWithDate:(NSString *)dateString;

/** 选择了时间后的回调*/
@property (nonatomic, strong)   RACSubject     *selectDateSubject;

@end
