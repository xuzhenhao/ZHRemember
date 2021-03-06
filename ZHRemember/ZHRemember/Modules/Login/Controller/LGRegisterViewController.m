//
//  LGRegisterViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/23.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "LGRegisterViewController.h"
#import "LoginConfig.h"
#import "LGRegisterViewModel.h"
#import "LGLoginViewController.h"

@interface LGRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *zoneButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/**显示/隐藏密码按钮*/
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;


@property (nonatomic, strong)   LGRegisterViewModel     *viewModel;

@end

@implementation LGRegisterViewController

+ (instancetype)registerViewController{
   return [self viewControllerWithStoryBoard:LoginStoryBoardName];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupObserver];
}

#pragma mark - setupUI
- (void)setupUI{
    self.registButton.layer.cornerRadius = 5;
    self.registButton.layer.masksToBounds = YES;
}
- (void)setupObserver{
    RAC(self,viewModel.mobilePhone) = self.phoneNumTextField.rac_textSignal;
    RAC(self,viewModel.password) = self.pwdTextField.rac_textSignal;
    RAC(self,viewModel.smsCode) = self.smsTextField.rac_textSignal;
    
    self.registButton.rac_command = self.viewModel.registCommad;
    self.smsButton.rac_command = self.viewModel.smsCommand;
    
    @weakify(self)
    [[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self navigateToLoginViewController];
    }];
    [RACObserve(self.registButton, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UIColor *bgColor = [x boolValue] ? RGBColor(92, 176, 133): RGBAColor(92, 176, 133, 0.6);
        self.registButton.backgroundColor = bgColor;
    }];
    [[[self.showPwdButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        BOOL isHidePwd = self.pwdTextField.secureTextEntry;
        self.pwdTextField.secureTextEntry = !isHidePwd;
        self.showPwdButton.selected = isHidePwd;
    }];
    [[RACObserve(self.viewModel, smsBtnDesc) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.smsButton setTitle:x forState:UIControlStateNormal];
        [self.smsButton setTitle:x forState:UIControlStateDisabled];
    }];
    [[[self.viewModel.registCommad.executionSignals
       .switchToLatest deliverOnMainThread]
      filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [HBHUDManager showMessage:@"注册成功" done:^{
                [self navigateToLoginViewController];
        }];
    }];
    
    [[[RACObserve(self.viewModel, error) filter:^BOOL(id  _Nullable value) {
        return value != nil;
    }] deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        NSError *error = x;
        [HBHUDManager showMessage:error.userInfo[NSErrorDescKey]];
    }];
    [[RACObserve(self.viewModel, zoneCodeDesc) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.zoneButton setTitle:[NSString stringWithFormat:@"%@",x] forState:UIControlStateNormal];
    }];
}

#pragma mark - action
- (void)navigateToLoginViewController{
    LGLoginViewController *vc = [LGLoginViewController loginViewController];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)didClickZoneButton:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手机号地区" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"中国大陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewModel.zoneCode = ChinaZoneCode;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"香港" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewModel.zoneCode = XiangGangZoneCode;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"澳门" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewModel.zoneCode = AoMengZoneCode;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"台湾" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewModel.zoneCode = TaiWangZoneCode;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - getter
- (LGRegisterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [LGRegisterViewModel new];
    }
    return _viewModel;
}

@end
