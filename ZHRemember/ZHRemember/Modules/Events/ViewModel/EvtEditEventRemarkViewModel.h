//
//  EvtEditEventRemarkViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvtEditEventRemarkViewModel : NSObject

@property (nonatomic, copy)     NSString    *remark;

+ (instancetype)viewModelWithRemark:(NSString *)remark;

@end
