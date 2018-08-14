//
//  EvtEventListController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/19.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListController.h"
#import "EvtEventHeader.h"
#import "EvtEditEventController.h"

@interface EvtEventListController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 添加事件按钮*/
@property (nonatomic, strong)   UIButton     *addEventButton;

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
    
    [self.view addSubview:self.addEventButton];
}
#pragma mark - action
- (void)didClickAddEventButton:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    EvtEditEventController *editVC = [EvtEditEventController editEventController];
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test" forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

#pragma mark - getter
- (UIButton *)addEventButton{
    if (_addEventButton == nil) {
        _addEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addEventButton.frame = CGRectMake(ZHScreenWidth - 60, ZHScreenHeight - 250, 50, 50);
        _addEventButton.layer.cornerRadius = 25;
        _addEventButton.backgroundColor = [UIColor greenColor];
        [_addEventButton addTarget:self action:@selector(didClickAddEventButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addEventButton;
}

@end
