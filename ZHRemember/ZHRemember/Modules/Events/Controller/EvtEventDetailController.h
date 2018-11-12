//
//  EvtEventDetailController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvtEventModel;

/**删除事件成功通知*/
extern NSString *EvtDeleteEventSuccessNotification;

/**
 事件详情页
 */
@interface EvtEventDetailController : UIViewController

+ (instancetype)detailViewControlle;

+ (instancetype)detailViewControlleWithEvent:(EvtEventModel *)event;

@end
