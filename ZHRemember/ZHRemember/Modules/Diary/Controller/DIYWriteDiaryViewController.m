//
//  DIYWriteDiaryViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYWriteDiaryViewController.h"
#import "DIYDiaryConfig.h"

@interface DIYWriteDiaryViewController ()
/**头部状态栏视图*/
@property (weak, nonatomic) IBOutlet UIView *statusView;
/**日历视图*/
@property (weak, nonatomic) IBOutlet UIView *timeView;


@end

@implementation DIYWriteDiaryViewController
+ (instancetype)writeDiaryViewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI{
    self.title = @"写日记";
    [self setupStatusView];
}
- (void)setupStatusView{
    self.statusView.layer.cornerRadius = 5;
    self.statusView.layer.masksToBounds = YES;
    self.statusView.layer.borderWidth = 0.5;
    self.statusView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.timeView.layer.cornerRadius = 5;
    self.timeView.layer.masksToBounds = YES;
}
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

@end
