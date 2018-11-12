//
//  EvtEditEventDateCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventDateCell.h"
#import "EvtEditEventDateViewModel.h"

NSString *dateCellBeginPickDateEvent = @"EvtDateCellBeginPickDateEvent";

@interface EvtEditEventDateCell()<ZHTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong)   NSDateFormatter     *dateFormat;

@property (nonatomic, strong)   ZHTableViewItem     *item;


@end

@implementation EvtEditEventDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self bindActions];
}
#pragma mark - setupUI
- (void)updateWithData:(ZHTableViewItem *)data{
    self.item = data;
    EvtEditEventDateViewModel *dateVM = data.data;
    self.textField.text = dateVM.dateFormat;
    
    @weakify(self)
    [RACObserve(dateVM, dateFormat) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.textField.text = dateVM.dateFormat;
    }];
}

#pragma mark - action

- (void)bindActions{
    @weakify(self)
    
    [[self.textField rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //驱动VM传递事件
        @strongify(self)
        EvtEditEventDateViewModel *viewModel = self.item.data;
        [viewModel.selectDateSubject sendNext:self.item.indexPath];
    }];
    
}
#pragma mark - getter
- (NSDateFormatter *)dateFormat{
    if (_dateFormat == nil) {
        _dateFormat = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _dateFormat;
}


@end
