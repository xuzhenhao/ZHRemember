//
//  EvtEditEventTitleCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventTitleCell.h"
#import "EvtEditEventTitleViewModel.h"

@interface EvtEditEventTitleCell()
<UITextFieldDelegate,ZHTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong)   EvtEditEventTitleViewModel     *viewModel;

@end

@implementation EvtEditEventTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self bindActions];
}
#pragma mark - ZHTableViewCellProtocol
- (void)updateWithData:(ZHTableViewItem *)data{
    
    EvtEditEventTitleViewModel *viewModel = data.data;
    self.viewModel = viewModel;
    self.textField.text = viewModel.eventName;
    
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    switch (textField.returnKeyType) {
        case UIReturnKeyDone:
            [textField resignFirstResponder];
            break;
            
        default:
            break;
    }
    return YES;
}

#pragma mark - private
- (void)bindActions{
    @weakify(self)
    [[self.textField rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self showEditStateView];
    }];
    [[self.textField rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self hideEditStateView];
    }];
    RAC(self,viewModel.eventName) = self.textField.rac_textSignal;
    
}

@end
