//
//  EvtEventDetailViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 事件详情VM
 */
@interface EvtEventDetailViewModel : NSObject

/** 事件id*/
@property (nonatomic, copy)     NSString    *eventId;
/** 删除事件*/
@property (nonatomic, strong)   RACCommand     *deleteCommand;

@end
