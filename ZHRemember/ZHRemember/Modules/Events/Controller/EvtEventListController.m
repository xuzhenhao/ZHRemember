//
//  EvtEventListController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListController.h"
#import "EvtEventHeader.h"

@interface EvtEventListController ()

@end

@implementation EvtEventListController

+ (instancetype)eventListController{
   return [self viewControllerWithStoryBoard:EvtEventStoryboard];
}
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}
#pragma mark - UI
- (void)initialSetup{
    self.view.backgroundColor = [UIColor yellowColor];
}



@end
