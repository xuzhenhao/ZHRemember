//
//  EvtEventApi.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvtEventModel.h"

@interface EvtEventApi : NSObject

+ (void)saveEvent:(EvtEventModel *)event
             done:(void(^)(BOOL success,NSDictionary *result))doneHandler;
+ (void)getEventListsWithPage:(NSInteger)page
                         done:(void(^)(NSArray<EvtEventModel *> *eventLists,NSDictionary *result))doneHandler;
@end
