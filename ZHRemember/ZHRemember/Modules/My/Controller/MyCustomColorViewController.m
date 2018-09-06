//
//  MyCustomColorViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/5.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyCustomColorViewController.h"
#import "WSColorImageView.h"

@interface MyCustomColorViewController ()
/** <#desc#>*/
@property (nonatomic, strong)   WSColorImageView     *colorView;

@property (nonatomic, strong)   UIView     *resultView;

@end

@implementation MyCustomColorViewController
+ (instancetype)viewController{
    MyCustomColorViewController *vc = [MyCustomColorViewController new];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.colorView];
    __weak typeof(self)weakself = self;
    self.colorView.currentColorBlock = ^(UIColor *color, NSString *rgbStr) {
        weakself.resultView.backgroundColor = color;
    };
    [self.view addSubview:self.resultView];
    self.resultView.ZH_y = self.colorView.ZH_bottom + 20;
}

#pragma mark - getter
- (WSColorImageView *)colorView{
    if (!_colorView) {
        CGFloat width = ZHScreenWidth - 40;
        _colorView = [[WSColorImageView alloc] initWithFrame:CGRectMake(20, 20, width, width)];
    }
    return _colorView;
}
- (UIView *)resultView{
    if (!_resultView) {
        CGFloat width = 150;
        CGFloat xpos = ( ZHScreenWidth - width )/2;
        _resultView = [[UIView alloc] initWithFrame:CGRectMake(xpos, 0, width, 50)];
    }
    return _resultView;
}

@end
