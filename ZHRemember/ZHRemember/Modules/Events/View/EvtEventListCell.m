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
/**容器view*/
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindTypeTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;


@property (nonatomic, strong)   EvtEventListEventsViewModel     *viewModel;

@end

@implementation EvtEventListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}
- (void)setupView{
    self.shadowView.layer.cornerRadius = 4;
    self.shadowView.layer.shadowColor = [UIColor zh_shadowColor].CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(0, 4);
    self.shadowView.layer.shadowRadius = 5;
    self.shadowView.layer.shadowOpacity = 1;
    
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.masksToBounds = YES;
    
    self.timeView.layer.cornerRadius = 5;
    self.timeView.layer.masksToBounds = YES;
}
- (void)bindViewModel:(id)viewModel{
    self.viewModel = viewModel;
    
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.coverURLStr] placeholderImage:[UIImage zh_imageWithColor:[UIColor zh_coverColor] size:self.coverImageView.bounds.size]];
    self.eventNameLabel.text = self.viewModel.eventName;
    self.remindTimeLabel.text = self.viewModel.remindTime;
    self.beginTimeLabel.text = self.viewModel.beginTime;
    self.weekTimeLabel.text = self.viewModel.weekTime;
    self.remarkLabel.text = self.viewModel.remark;
    self.remindTypeTipLabel.text = self.viewModel.remindTypeTips;
    self.tagLabel.text = self.viewModel.tagName;
}


@end
