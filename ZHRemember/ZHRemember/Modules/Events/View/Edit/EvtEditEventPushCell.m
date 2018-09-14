//
//  EvtEditEventPushCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventPushCell.h"
#import "EvtEventHeader.h"
#import "EvtEditEventPushViewModel.h"

@interface EvtEditEventPushCell()<ZHTableViewCellProtocol>

@property (nonatomic, strong)   EvtEditEventPushViewModel     *viewModel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation EvtEditEventPushCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupObserver];
}
- (void)updateWithData:(ZHTableViewItem *)data{
    self.viewModel = data.data;
    
    @weakify(self)
    [[RACObserve(self.viewModel, isEnablePush) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.switchButton.on = [x boolValue];
    }];
    self.switchButton.on = self.viewModel.isEnablePush;
}
- (void)setupObserver{
    @weakify(self)
    [[self.switchButton rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewModel.isEnablePush = ((UISwitch *)x).on;
    }];
    
}

@end
