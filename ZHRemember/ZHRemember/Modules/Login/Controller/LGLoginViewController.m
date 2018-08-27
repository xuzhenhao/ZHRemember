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

@interface LGLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong)   LGLoginViewModel     *viewModel;

@end

@implementation LGLoginViewController

+ (instancetype)loginViewController{
    return [self viewControllerWithStoryBoard:LoginStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindAction];
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
}

#pragma mark - getter
- (LGLoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [LGLoginViewModel new];
    }
    return _viewModel;
}

@end