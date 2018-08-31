//
//  DIYWriteDiaryViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYWriteDiaryViewController.h"
#import "DIYDiaryConfig.h"
#import <YYText/YYText.h>
#import "DIYWriteDiaryViewModel.h"
#import <PGDatePicker/PGDatePickManager.h>

@interface DIYWriteDiaryViewController ()<YYTextViewDelegate>
/**头部状态栏视图*/
@property (weak, nonatomic) IBOutlet UIView *statusView;
/**日历视图*/
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *monthDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourDescLabel;

/**日记内容容器view*/
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**背景信纸*/
@property (weak, nonatomic) IBOutlet UIImageView *letterImageView;
/** 日记输入框*/
@property (nonatomic, strong)   YYTextView     *textView;

/**系统按钮*/
/** 保存按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *saveItem;
/** 键盘辅助工具条*/
@property (nonatomic, strong)   UIToolbar     *toolBar;

@property (nonatomic, strong)   DIYWriteDiaryViewModel     *viewModel;

@end

@implementation DIYWriteDiaryViewController
+ (instancetype)writeDiaryViewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI{
    self.title = @"写日记";
    self.navigationItem.rightBarButtonItem = self.saveItem;
    [self setupStatusView];
    [self setupContentView];
    [self bindAction];
}
- (void)setupStatusView{
    self.statusView.layer.cornerRadius = 5;
    self.statusView.layer.masksToBounds = YES;
    self.statusView.layer.borderWidth = 0.5;
    self.statusView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.timeView.layer.cornerRadius = 5;
    self.timeView.layer.masksToBounds = YES;
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] init];
    [self.timeView addGestureRecognizer:timeTap];
    @weakify(self)
    [[timeTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        [self didClickSelectDateAction];
    }];
}
- (void)setupContentView{
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
- (void)bindAction{
    RAC(self,monthDescLabel.text) = RACObserve(self.viewModel, monthDesc);
    RAC(self,dayDescLabel.text) = RACObserve(self.viewModel, dayDesc);
    RAC(self,hourDescLabel.text) = RACObserve(self.viewModel, hourDesc);
    RAC(self,weekDescLabel.text) = RACObserve(self.viewModel, weekDesc);
    
    @weakify(self)
    [RACObserve(self.textView, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.viewModel.diaryText = x;
    }];
    
    self.saveItem.rac_command = self.viewModel.saveDiaryCommand;
    [[self.viewModel.saveDiaryCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"保存成功" done:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            [HBHUDManager showMessage:@"保存失败"];
        }
    }];
}
#pragma mark - action
- (void)didClickToolbarFinishAction:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
}
- (void)didClickSelectDateAction{
    @weakify(self)
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        @strongify(self)
        [self.viewModel updateTimeWithDateComponents:dateComponents];
    };
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    
    [self presentViewController:datePickManager animated:false completion:nil];
}

#pragma mark - getter
- (YYTextView *)textView{
    if (_textView == nil) {
        _textView = [YYTextView new];
        
        _textView.placeholderText = @"每一段时光都值得纪念";
        _textView.placeholderFont = [UIFont systemFontOfSize:16];
        _textView.placeholderTextColor = RGBColor(178, 178, 178);
        _textView.delegate = self;
        
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textColor = RGBColor(0, 0, 0);
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 24;
        _textView.linePositionModifier = mod;
        
        _textView.inputAccessoryView = self.toolBar;
//        _textView.textParser = [HBTWriteRecordTextParser new];
    }
    return _textView;
}
- (DIYWriteDiaryViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [DIYWriteDiaryViewModel defaultViewModel];
    }
    return _viewModel;
}
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
- (UIBarButtonItem *)saveItem{
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return _saveItem;
}
- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        UIBarButtonItem *fixBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *finBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didClickToolbarFinishAction:)];
        finBtn.tintColor = [UIColor blackColor];
        fixBtn.tintColor = [UIColor clearColor];
        
        [_toolBar setBackgroundImage:[UIImage zh_imageWithColor:[UIColor clearColor] size:CGSizeMake(ZHScreenWidth, 44)] forToolbarPosition:0 barMetrics:UIBarMetricsDefault];
        
        _toolBar.items = @[fixBtn,finBtn];
        
    }
    return _toolBar;
}
@end
