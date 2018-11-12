//
//  HBUpdateTipView.m
//  store
//
//  Created by cloud on 16/12/12.
//  Copyright © 2016年 haibao. All rights reserved.
//

#import "HBUpdateTipView.h"
#import "UIView+ZHLayout.h"
#import "UILabel+ZHSpace.h"

@interface HBUpdateTipView()

@property (nonatomic, strong) UIWindow    *window;
@property (nonatomic, strong) UIView      *backgroundView;
/** 更新提示标题*/
@property (nonatomic, copy) NSString* updateTitle;
/** 更新提示内容*/
@property (nonatomic, strong) NSArray<NSString *> *updateContents;
/** 背景图片*/
@property (nonatomic, strong) UIImageView *bgImageView;
/** 火箭图片*/
@property (nonatomic, strong) UIImageView *rocketImageView;
/** 关闭图片*/
@property (nonatomic, strong) UIImageView *closeImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容*/
@property (nonatomic, strong) UILabel *contentLabel;
/**更新按钮*/
@property (nonatomic, strong) UIButton *updateButton;

/** 提示框高度*/
@property (nonatomic, assign) CGFloat updateViewHeight;
@end

@implementation HBUpdateTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.bgImageView];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.updateButton];
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)updateView{
    CGFloat viewWidht = 282;
//    CGFloat viewWidht = UIScreenSize.width - 93;
    CGFloat margin = (ZHScreenWidth - viewWidht) / 2;
    
    self.bgImageView.ZH_y = 0;
    self.bgImageView.ZH_x = 0;
    self.bgImageView.ZH_width = viewWidht;

    self.titleLabel.ZH_y = self.bgImageView.ZH_bottom + 20;
    self.titleLabel.ZH_x = 30;
    self.titleLabel.ZH_height = 17;
    
    self.contentLabel.ZH_y = self.titleLabel.ZH_bottom + 17;
    self.contentLabel.ZH_x = 30;
    self.contentLabel.ZH_width = viewWidht - 60;
    self.contentLabel.preferredMaxLayoutWidth = viewWidht - 60;
    if ([self.contentLabel.text containsString:@"\n"]) {
        //多条更新信息
        [UILabel zh_changeLineSpaceForLabel:self.contentLabel WithSpace:10];
    }else{
        //单条更新信息
        [UILabel zh_changeLineSpaceForLabel:self.contentLabel WithSpace:3];
    }
    
    [self.contentLabel sizeToFit];
   
    self.updateButton.ZH_x = 30;
    self.updateButton.ZH_y = self.contentLabel.ZH_bottom + 21;
    self.updateButton.ZH_width = viewWidht - 60;
    self.updateButton.ZH_height = 40;
    
    self.updateViewHeight = self.updateButton.ZH_bottom + 15;
    //布局火箭图片
    CGFloat y = (ZHScreenHeight - self.updateViewHeight) / 2.0 - 49;//49为tabbar高度
    self.rocketImageView.ZH_bottom = self.bgImageView.ZH_height - 57 + y;
    self.rocketImageView.ZH_centerX = self.bgImageView.ZH_centerX + margin;
    
    //布局关闭图片
    self.closeImageView.ZH_centerY = y;
    self.closeImageView.ZH_centerX = margin + viewWidht;
}

#pragma mark - Method

- (void)show{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.hidden = NO;
    self.window.windowLevel = UIWindowLevelAlert;
    
    //点击其他区域也能取消弹框
//    UITapGestureRecognizer *tagGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonAction)];
//    [self.window addGestureRecognizer:tagGes];
    
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    [self.window addSubview:self.backgroundView];
    [self.window addSubview:self.rocketImageView];
    [self.window addSubview:self.closeImageView];
    [self.backgroundView addSubview:self];
    
    [self updateView];
    
    CGFloat height = self.updateViewHeight;
    CGFloat y = (ZHScreenHeight - height) / 2.0 - 49;//49为tabbar高度
    CGRect frame = CGRectMake((ZHScreenWidth - 282 )/2, y, 282, height);
    self.frame = frame;
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
    
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        self.window.hidden = YES;
        self.window = nil;
    }];
}

- (void)showWithTitle:(NSString *)tipTitle contents:(NSString *)contents{
    self.titleLabel.text = tipTitle;
    self.contentLabel.text = contents;
    [self.titleLabel sizeToFit];
    [self.contentLabel sizeToFit];
    
    [self show];
}
+ (void)showWithTitle:(NSString *)tipTitle contents:(NSString *)contents done:(void (^)(void))done{
    HBUpdateTipView *tipView = [HBUpdateTipView new];
    [tipView showWithTitle:tipTitle contents:contents];
    tipView.confirmAction = done;
}

#pragma mark - actions
- (void)okButtonAction:(UIButton *)button{
    [self dismiss];
    if (self.confirmAction) {
        self.confirmAction();
    }
}

- (void)cancelButtonAction {
    [self dismiss];
    if (self.cancelAction) {
        self.cancelAction();
    }
}

#pragma mark - getter&setter
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    }
    return _backgroundView;
}
- (UIImageView *)bgImageView{
    if (_bgImageView != nil) {
        return _bgImageView;
    }
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update-backGround"]];
    return _bgImageView;
}
- (UIImageView *)rocketImageView{
    if (_rocketImageView != nil) {
        return _rocketImageView;
    }
    _rocketImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update-rocket"]];
    return _rocketImageView;
}
- (UIImageView *)closeImageView{
    if (_closeImageView != nil) {
        return _closeImageView;
    }
    _closeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"update-close"]];
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonAction)];
    [_closeImageView addGestureRecognizer:tag];
    _closeImageView.userInteractionEnabled = YES;
    
    return _closeImageView;
}

- (UILabel *)titleLabel{
    if (_titleLabel != nil) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textColor = RGBColor(29, 34, 38);
    return _titleLabel;
}


- (UIButton *)updateButton{
    if (_updateButton != nil) {
        return _updateButton;
    }
    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _updateButton.backgroundColor = RGBColor(0, 185, 251);
    [_updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
    [_updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_updateButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _updateButton.layer.cornerRadius = 5.f;
    _updateButton.layer.masksToBounds = YES;
    
    return _updateButton;
}

- (UILabel *)contentLabel{
    if (_contentLabel != nil) {
        return _contentLabel;
    }
    _contentLabel = [UILabel new];
    _contentLabel.textColor = RGBColor(122, 122, 122);
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    
    return _contentLabel;
}
@end
