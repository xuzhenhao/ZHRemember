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
#import "DIYSelectMoodViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePreviewController/TZImagePreviewController.h>
#import "DIYSelectWallPaperViewController.h"

NSString *DIYDiaryChangedNotification = @"DIYDiaryChangedNotification";
NSInteger PublishDiaryReward = 5;//发表日记奖励

@interface DIYWriteDiaryViewController ()<YYTextViewDelegate>
/**头部状态栏视图*/
@property (weak, nonatomic) IBOutlet UIView *statusView;
/**日历视图*/
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *monthDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourDescLabel;
/**天气心情视图*/
@property (weak, nonatomic) IBOutlet UIView *weatherMoodView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

/**日记内容容器view*/
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**背景信纸*/
@property (weak, nonatomic) IBOutlet UIImageView *letterImageView;
/** 日记输入框*/
@property (nonatomic, strong)   YYTextView     *textView;

/**系统按钮*/
/** 保存按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *saveItem;
/** 删除按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *deleteItem;
/** 键盘辅助工具条*/
@property (nonatomic, strong)   UIToolbar     *toolBar;

@property (nonatomic, strong)   DIYWriteDiaryViewModel     *viewModel;

@end

@implementation DIYWriteDiaryViewController
+ (instancetype)writeDiaryViewController{
    DIYWriteDiaryViewController *vc = [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
    vc.viewModel = [DIYWriteDiaryViewModel defaultViewModel];
    return vc;
}
+ (instancetype)writeDiaryViewControllerWithModel:(ZHDiaryModel *)model{
    DIYWriteDiaryViewController *vc = [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
    vc.viewModel = [DIYWriteDiaryViewModel viewModelWithModel:model];
    
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI{
    self.title = @"写日记";
    
    if (self.viewModel.diaryId) {
        self.navigationItem.rightBarButtonItems = @[self.saveItem,self.deleteItem];
    }else{
        self.navigationItem.rightBarButtonItem = self.saveItem;
    }
    
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
    //点击了心情天气选择
    UITapGestureRecognizer *moodTap = [[UITapGestureRecognizer alloc] init];
    [self.weatherMoodView addGestureRecognizer:moodTap];
    [[moodTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        DIYSelectMoodViewController *selectVC = [DIYSelectMoodViewController viewController];
        [self.navigationController pushViewController:selectVC animated:YES];
        @weakify(self)
        selectVC.selectMoodWeatherCallback = ^(NSString *moodName, NSString *weatherName, NSString *paperName) {
            @strongify(self)
            self.viewModel.weathImageName = weatherName ?:self.viewModel.weathImageName;
            self.viewModel.moodImageName = moodName ?: self.viewModel.moodImageName;
        };
    }];
    //点击了照片选择
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] init];
    [self.pictureView addGestureRecognizer:photoTap];
    [[photoTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        if (self.viewModel.diaryImageURL) {
            [self showPreViewImageActionSheet];
        }else{
            [self didClickSelectImageAction];
        }
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
    [[RACObserve(self.viewModel, diaryText) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.textView.text = x;
    }];
    [[RACObserve(self.viewModel, weathImageName) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.weatherImageView.image = [UIImage imageNamed:x];
    }];
    [[RACObserve(self.viewModel, moodImageName) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.moodImageView.image = [UIImage imageNamed:x];
    }];
    [[RACObserve(self.viewModel, diaryImageURL) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (!x) {
            return ;
        }
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:x] placeholderImage:[UIImage imageNamed:@"diary-photo-bg"]];
    }];
    [[[RACObserve(self.viewModel, letterImageName) deliverOnMainThread] filter:^BOOL(id  _Nullable value) {
        return [value stringValue].length > 0;
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.letterImageView.image = [UIImage imageNamed:x];
    }];
    
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
                [[NSNotificationCenter defaultCenter] postNotificationName:DIYDiaryChangedNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self checkIfNeedUpdateMoney];
        }else{
            [HBHUDManager showMessage:@"保存失败"];
        }
    }];
    
    [[self.viewModel.deleteCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            [HBHUDManager showMessage:@"已删除" done:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:DIYDiaryChangedNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [HBHUDManager showMessage:@"删除失败,请稍后重试"];
        }
    }];
    [[self.viewModel.rewardCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(id  _Nullable x) {
         BOOL isSuccess = [x boolValue];
         if (isSuccess) {
             [HBHUDManager showMessage:[NSString stringWithFormat:@"记忆结晶+%ld",PublishDiaryReward]];
             [[ZHCache sharedInstance] setUserPublished];
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
- (void)didClickSelectImageAction{
    TZImagePickerController *imagePickVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickVC.barItemTextColor = [UIColor zh_themeColor];
    imagePickVC.showSelectBtn = NO;
    imagePickVC.allowCrop = YES;
    
    CGFloat cropHeight = ZHScreenWidth ;
    imagePickVC.cropRect = CGRectMake(0,(ZHScreenHeight - cropHeight)/2 ,ZHScreenWidth,cropHeight) ;
    
    @weakify(self)
    [imagePickVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self)
        [self.viewModel updateDiaryImage:photos.lastObject];
    }];
    [self presentViewController:imagePickVC animated:YES completion:nil];
    
}
- (void)didClickPreviewImageAction{
    TZImagePickerController *imagePickVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickVC.barItemTextColor = [UIColor zh_themeColor];
    imagePickVC.showSelectBtn = NO;
    imagePickVC.allowCrop = YES;
    
    NSURL *preUrl = [NSURL URLWithString:self.viewModel.diaryImageURL];
    TZImagePreviewController *preVC = [[TZImagePreviewController alloc] initWithPhotos:@[preUrl] currentIndex:0 tzImagePickerVc:imagePickVC];
    [preVC setSetImageWithURLBlock:^(NSURL *URL, UIImageView *imageView, void (^completion)(void)) {
        [imageView sd_setImageWithURL:URL];
    }];
    [self presentViewController:preVC animated:YES completion:nil];
}
/**弹窗提示查看还是编辑*/
- (void)showPreViewImageActionSheet{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"更换图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didClickSelectImageAction];
    }];
    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"浏览图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self didClickPreviewImageAction];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:editAction];
    [alertVC addAction:previewAction];
    [alertVC addAction:cancleAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)showDeleteDiaryAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除日记?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel.deleteCommand execute:nil];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:editAction];
    [alertVC addAction:cancleAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (IBAction)didClickSelectLetter:(UIButton *)sender {
    DIYSelectWallPaperViewController *paperVc = [DIYSelectWallPaperViewController paperViewController];
    [self.navigationController pushViewController:paperVc animated:YES];
    
    __weak typeof(self)weakself = self;
    paperVc.selectPaperCallback = ^(NSString *imageName) {
        weakself.viewModel.letterImageName = imageName;
    };
}
#pragma mark - utils
- (void)checkIfNeedUpdateMoney{
    //如果是第一次发表，更新账户金钱
    if ([ZHCache sharedInstance].isPublished) {
        return;
    }
    NSInteger currentMoney = [[ZHCache sharedInstance].money integerValue];
    NSString *updateMoney = [NSString stringWithFormat:@"%ld",(currentMoney + PublishDiaryReward)];
    [[ZHCache sharedInstance] updateUserMoney:updateMoney];
    [self.viewModel.rewardCommand execute:updateMoney];
}

#pragma mark - getter
- (YYTextView *)textView{
    if (_textView == nil) {
        _textView = [YYTextView new];
        
        _textView.placeholderText = @"此刻想说点什么?";
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
- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}
- (UIBarButtonItem *)saveItem{
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return _saveItem;
}
- (UIBarButtonItem *)deleteItem{
    if (!_deleteItem) {
        _deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(showDeleteDiaryAlertView)];
    }
    return _deleteItem;
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
