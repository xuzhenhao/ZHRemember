//
//  EvtEventListCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/16.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEventListCell.h"
#import "EvtEventListEventsViewModel.h"

@interface EvtEventListCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong)   EvtEventListEventsViewModel     *viewModel;

@end

@implementation EvtEventListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)bindViewModel:(id)viewModel{
    self.viewModel = viewModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.coverURLStr]];
    self.eventNameLabel.text = self.viewModel.eventName;
    self.remindTimeLabel.text = self.viewModel.remindTime;
    self.beginTimeLabel.text = self.viewModel.beginTime;
    self.weekTimeLabel.text = self.viewModel.weekTime;
    self.remarkLabel.text = self.viewModel.remark;
}


@end
