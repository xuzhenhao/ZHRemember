//
//  DIYWriteDiaryViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYWriteDiaryViewController.h"

@interface DIYWriteDiaryViewController ()

@end

@implementation DIYWriteDiaryViewController
+ (instancetype)writeDiaryViewController{
    return [self new];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI{
    self.title = @"写日记";
}


@end
