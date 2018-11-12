//
//  EvtEditEventSetTopCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventSetTopCell.h"
#import "EvtEventHeader.h"
#import "EvtEditEventSetTopViewModel.h"

@interface EvtEditEventSetTopCell()<ZHTableViewCellProtocol>

@property (nonatomic, strong)   EvtEditEventSetTopViewModel     *viewModel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation EvtEditEventSetTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupObserver];
}
- (void)updateWithData:(ZHTableViewItem *)data{
    self.viewModel = data.data;
    
    @weakify(self)
    [[RACObserve(self.viewModel, isTop) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.switchButton.on = [x boolValue];
    }];
    self.switchButton.on = self.viewModel.isTop;
}
- (void)setupObserver{
    @weakify(self)
    [[self.switchButton rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewModel.isTop = ((UISwitch *)x).on;
    }];
    
}
@end
