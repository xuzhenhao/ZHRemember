//
//  EvtEventDetailController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/21.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventDetailController.h"
#import "EvtEventHeader.h"
#import "EvtEventModel.h"
#import "EvtEditEventController.h"
#import "EvtEventDetailViewModel.h"

@interface EvtEventDetailController ()

@property (nonatomic, strong)   EvtEventModel     *eventModel;
/** 更多操作按钮*/
@property (nonatomic, strong)   UIBarButtonItem   *moreItem;

@property (nonatomic, strong)   EvtEventDetailViewModel     *viewModel;

@end

@implementation EvtEventDetailController
+ (instancetype)detailViewControlle{
    return [self viewControllerWithStoryBoard:EvtEventStoryboard];
}
+ (instancetype)detailViewControlleWithEvent:(EvtEventModel *)event{
    EvtEventDetailController *eventVC = [self viewControllerWithStoryBoard:EvtEventStoryboard];
    eventVC.eventModel = event;
    eventVC.viewModel.eventId = event.eventId;
    
    return eventVC;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI{
    self.navigationItem.rightBarButtonItem = self.moreItem;
    
    [self bindActions];
}
- (void)bindActions{
    @weakify(self)
    
    [[self.viewModel.deleteCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - action
- (void)didClickMoreItem:(UIBarButtonItem *)sender{
    @weakify(self)
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"编辑"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                @strongify(self)
                                                [self navigateToEditViewController];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.viewModel.deleteCommand execute:nil];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)navigateToEditViewController{
    EvtEditEventController *editVC = [EvtEditEventController editEventControllerWithModel:self.eventModel];
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}


#pragma mark - getter&setter
- (UIBarButtonItem *)moreItem{
    if (!_moreItem) {
        _moreItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStyleDone target:self action:@selector(didClickMoreItem:)];
    }
    return _moreItem;
}
- (EvtEventDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [EvtEventDetailViewModel new];
    }
    return _viewModel;
}
@end
