//
//  EvtEditEventCoverCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventCoverCell.h"
#import "EvtEditEventCoverViewModel.h"

NSString *coverCellSelectImageEvent = @"EvtCoverCellSelectImageEvent";

@interface EvtEditEventCoverCell()<ZHTableViewCellProtocol>
/**编辑状态视图宽度约束*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateViewWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

/** <#desc#>*/
@property (nonatomic, strong)   ZHTableViewItem     *item;

@end

@implementation EvtEditEventCoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSetup];
}
- (void)initSetup{
    self.coverImageView.layer.cornerRadius = 5;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.userInteractionEnabled = YES;
    
    @weakify(self)
    UITapGestureRecognizer *sender = [[UITapGestureRecognizer alloc] init];
    [[sender rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        EvtEditEventCoverViewModel *vm = self.item.data;
        [vm.selectPhotoSubject sendNext:self.item.indexPath];
    }];
    [self.coverImageView addGestureRecognizer:sender];
}
#pragma mark - ZHTableViewCellProtocol
- (void)updateWithData:(ZHTableViewItem *)data{
    self.item = data;
    EvtEditEventCoverViewModel *coverVM = data.data;
    
    if (coverVM.coverImg) {
        self.coverImageView.image = coverVM.coverImg;
    }else{
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverVM.coverURLString] placeholderImage:[UIImage zh_imageWithColor:[UIColor zh_imagePlaceholdColor] size:self.coverImageView.bounds.size]];
    }
    
    
}
#pragma mark - event handler


@end
