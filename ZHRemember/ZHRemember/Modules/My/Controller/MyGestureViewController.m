//
//  MyGestureViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyGestureViewController.h"
#import "PCGestureUnlock.h"


@interface MyGestureViewController ()<CircleViewDelegate>

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@end

@implementation MyGestureViewController
+ (instancetype)gestureViewControllerWithType:(GestureControllerType)type{
    MyGestureViewController *vc = [MyGestureViewController new];
    vc.type = type;
    vc.hidesBottomBarWhenPushed = YES;
    
    return vc;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    // 进来先清空存的第一个密码
//    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
//}
#pragma mark - setupUI
- (void)setupUI{
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.msgLabel];
    
    switch (self.type) {
        case GestureControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureControllerTypeLogin:
            [self setupSubViewsLoginVc];
            [self setupPasswordVefiry];
            break;
        case GestureControllerTypeVerify:
            [self setupSubViewsVerifyVC];
            [self setupPasswordVefiry];
            break;
        default:
            break;
    }
}
- (void)setupSubViewsVerifyVC{
    self.title = @"验证手势密码";
    [self.lockView setType:CircleViewTypeVerify];
    [self.msgLabel showNormalMsg:gestureTextOldGesture];
}
/**
 录入手势密码
 */
- (void)setupSubViewsSettingVc
{
    self.title = @"设置手势密码";
    //清空第一次保存的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightItem)];
    [self.lockView setType:CircleViewTypeSetting];
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    [self.view addSubview:self.infoView];
}
/**
 使用手势密码登录
 */
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
}
- (void)setupPasswordVefiry{
    UIButton *rightBtn = [UIButton new];
    [self creatButton:rightBtn frame:CGRectMake(0, kScreenH - 60, kScreenW, 20) title:@"验证登录密码" alignment:UIControlContentHorizontalAlignmentCenter tag:0];
}
#pragma mark - action
- (void)didClickRightItem {
    // infoView取消选中
    [self infoViewDeselectedSubviews];
    // msgLabel提示文字复位
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    // 清除之前存储的密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
}
- (void)didClickBtn:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *txtField = alertController.textFields.firstObject;
        NSString *input = txtField.text;
        NSString *pwd = [ZHUserStore shared].currentUser.password;
        [self circleView:self.lockView type:CircleViewTypeVerify didCompleteLoginGesture:nil result:[pwd isEqualToString:input]];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    // infoView展示对应选中的圆
    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    
    if (equal) {
        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        if (self.settingCallback) {
            self.settingCallback(YES, gesture);
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (equal) {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
           [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } else {
        [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    if (self.verifyCallback) {
        self.verifyCallback(equal);
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView {
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews {
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}
#pragma mark - utils
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark - getter
- (PCCircleView *)lockView{
    if (!_lockView) {
        _lockView = [[PCCircleView alloc] init];
        _lockView.delegate = self;
    }
    return _lockView;
}
- (PCLockLabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[PCLockLabel alloc] init];
        _msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
        _msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.lockView.frame) - 30);
    }
    return _msgLabel;
}
- (PCCircleInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[PCCircleInfoView alloc] init];
        _infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
        _infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(_infoView.frame)/2 - 10);
    }
    return _infoView;
}


@end
