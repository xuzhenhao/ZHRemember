//
//  EvtEditEventRemarkCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventRemarkCell.h"
#import "EvtEditEventRemarkViewModel.h"

@interface EvtEditEventRemarkCell()<UITextFieldDelegate,ZHTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong)   EvtEditEventRemarkViewModel     *viewModel;

@end

@implementation EvtEditEventRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self bindActions];
}
- (void)updateWithData:(ZHTableViewItem *)data{
    self.viewModel = data.data;
    self.textField.text = self.viewModel.remark;
    
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
    RAC(self,viewModel.remark) = self.textField.rac_textSignal;
}


@end
