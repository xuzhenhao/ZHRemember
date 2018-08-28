//
//  LGResetPwdViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "LGResetPwdViewController.h"
#import "LoginConfig.h"
#import "LGResetPwdViewModel.h"

@interface LGResetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;


@property (nonatomic, strong)   LGResetPwdViewModel     *viewModel;

@end

@implementation LGResetPwdViewController
+ (instancetype)resetPwdViewController{
    return [self viewControllerWithStoryBoard:LoginStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindViewModel];
}
#pragma mark - setupUI
- (void)setupUI{
    self.finishButton.layer.cornerRadius = 5;
    self.finishButton.layer.masksToBounds = YES;
}
- (void)bindViewModel{
    RAC(self,viewModel.mobilePhone) = self.mobileTextField.rac_textSignal;
    RAC(self,viewModel.password) = self.pwdTextField.rac_textSignal;
    RAC(self,viewModel.smsCode) = self.smsTextField.rac_textSignal;
    
    self.finishButton.rac_command = self.viewModel.resetCommand;
    self.smsButton.rac_command = self.viewModel.smsCommand;
    
    @weakify(self)
    
    [RACObserve(self.finishButton, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIColor *bgColor = [x boolValue] ? RGBColor(92, 176, 133): RGBAColor(92, 176, 133, 0.6);
        self.finishButton.backgroundColor = bgColor;
    }];
    [[RACObserve(self.viewModel, smsBtnDesc) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.smsButton setTitle:x forState:UIControlStateNormal];
        [self.smsButton setTitle:x forState:UIControlStateDisabled];
    }];
    [[self.viewModel.resetCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"修改成功" done:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [HBHUDManager showMessage:@"修改失败，请检查后重试"];
        }
    }];
    [[[self.showPwdButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        BOOL isHidePwd = self.pwdTextField.secureTextEntry;
        self.pwdTextField.secureTextEntry = !isHidePwd;
        self.showPwdButton.selected = isHidePwd;
    }];
}

#pragma mark - getter
- (LGResetPwdViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [LGResetPwdViewModel new];
    }
    return _viewModel;
}

@end
