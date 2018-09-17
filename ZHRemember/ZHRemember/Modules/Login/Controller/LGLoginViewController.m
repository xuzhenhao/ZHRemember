//
//  LGLoginViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "LGLoginViewController.h"
#import "LoginConfig.h"
#import "LGLoginViewModel.h"
#import "LGResetPwdViewController.h"

@interface LGLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdButton;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;


@property (nonatomic, strong)   LGLoginViewModel     *viewModel;

@end

@implementation LGLoginViewController

+ (instancetype)loginViewController{
    return [self viewControllerWithStoryBoard:LoginStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindAction];
}
- (void)setupUI{
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
}
- (void)bindAction{
    self.loginButton.rac_command = self.viewModel.loginCommand;
    
    RAC(self,viewModel.account) = self.accountTextField.rac_textSignal;
    RAC(self,viewModel.password) = self.pwdTextField.rac_textSignal;
    
    @weakify(self)
    [RACObserve(self.loginButton, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIColor *bgColor = [x boolValue] ? RGBColor(92, 176, 133): RGBAColor(92, 176, 133, 0.6);
        self.loginButton.backgroundColor = bgColor;
    }];
    [[self.viewModel.loginCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        BOOL success = [x boolValue];
        if (success) {
            //登录成功
            UIViewController *mainVC = [[ZHMediator sharedInstance] zh_mainTabbarController];
            [UIViewController changeRootViewController:mainVC];
        }
    }];
    [[[self.resetPwdButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        LGResetPwdViewController *vc = [LGResetPwdViewController resetPwdViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[[self.showPwdButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        BOOL isHidePwd = self.pwdTextField.secureTextEntry;
        self.pwdTextField.secureTextEntry = !isHidePwd;
        self.showPwdButton.selected = isHidePwd;
    }];
    [[[RACObserve(self.viewModel, error) filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        NSError *error = x;
        [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
    }];
}

#pragma mark - getter
- (LGLoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [LGLoginViewModel new];
    }
    return _viewModel;
}

@end
