//
//  EvtTagListCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtTagListCell.h"
#import "EvtTagModel.h"

@interface EvtTagListCell()

@property (weak, nonatomic) IBOutlet UILabel *tagNameLabel;

@end

@implementation EvtTagListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)updatView{
    self.tagNameLabel.text = self.tagModel.tagName;
}
- (void)setTagModel:(EvtTagModel *)tagModel{
    _tagModel = tagModel;
    [self updatView];
}

@end
