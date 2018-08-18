//
//  EvtEditEventController.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvtEventModel;

/**编辑/保存事件成功通知*/
extern NSString *EvtEditEventSuccessNotification;

@interface EvtEditEventController : UIViewController

+ (instancetype)editEventController;

/**
 工厂方法，编辑时传入原有数据

 @param model 事件数据模型
 */
+ (instancetype)editEventControllerWithModel:(EvtEventModel *)model;

@end
