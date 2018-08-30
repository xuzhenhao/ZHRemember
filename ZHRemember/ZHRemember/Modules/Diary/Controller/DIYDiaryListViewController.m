//
//  DIYDiaryListViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryListViewController.h"
#import "DIYWriteDiaryViewController.h"

@interface DIYDiaryListViewController ()

/** 写日记按钮*/
@property (nonatomic, strong)   UIButton     *writeDiaryButton;
@end

@implementation DIYDiaryListViewController
+ (instancetype)diaryListViewController{
    return [self new];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
#pragma mark - setupUI
- (void)setupUI{
    self.title = @"日记本";
    
    [self.view addSubview:self.writeDiaryButton];
}

#pragma mark - action
- (void)didClickWriteDiaryButton:(UIButton *)sender{
    DIYWriteDiaryViewController *writeVC = [DIYWriteDiaryViewController writeDiaryViewController];
    writeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:writeVC animated:YES];
}

#pragma mark - getter
- (UIButton *)writeDiaryButton{
    if (_writeDiaryButton == nil) {
        _writeDiaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeDiaryButton setImage:[UIImage imageNamed:@"event-write-pen"] forState:UIControlStateNormal];
        _writeDiaryButton.frame = CGRectMake(ZHScreenWidth - 60, ZHScreenHeight - 250, 50, 50);
        
        _writeDiaryButton.backgroundColor = [UIColor zh_themeColor];
        _writeDiaryButton.layer.cornerRadius = 25;
        _writeDiaryButton.layer.shadowOffset = CGSizeMake(0, 8);
        _writeDiaryButton.layer.shadowOpacity = 0.5;
        _writeDiaryButton.layer.shadowColor = [UIColor zh_themeColor].CGColor;
        _writeDiaryButton.layer.shadowRadius = 12;
        
        [_writeDiaryButton addTarget:self action:@selector(didClickWriteDiaryButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeDiaryButton;
}


@end
