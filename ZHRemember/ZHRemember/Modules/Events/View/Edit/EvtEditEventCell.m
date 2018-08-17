//
//  EvtEditEventCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/25.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventCell.h"

static NSInteger stateViewWidth = 3;

@interface EvtEditEventCell()
/** 当前正在编辑状态指示*/
@property (nonatomic, strong)   UIView     *stateView;

@end

@implementation EvtEditEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
- (void)setupUI{
    [self.contentView addSubview:self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(0);
    }];
}
- (void)showEditStateView{
    [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(stateViewWidth);
    }];
    [self.contentView layoutIfNeeded];
}
- (void)hideEditStateView{
    [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
    }];
    [self.contentView layoutIfNeeded];
}

#pragma mark - getter
- (UIView *)stateView{
    if (_stateView == nil) {
        _stateView = [UIView new];
        _stateView.backgroundColor = RGBColor(92, 176, 133);
    }
    return _stateView;
}

@end
