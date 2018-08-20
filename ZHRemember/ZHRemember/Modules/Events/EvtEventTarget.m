//
//  EvtEventTarget.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventTarget.h"
#import "EvtEventListController.h"
#import "EvtTagManagerController.h"

@implementation EvtEventTarget

- (UIViewController *)eventListViewController{
    return [EvtEventListController eventListController];
}
- (UIViewController *)eventTagViewController{
    return [EvtTagManagerController tagController];
}
@end
