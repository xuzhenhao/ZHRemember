//
//  EvtEditEventController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/7/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventController.h"
#import "EvtEventHeader.h"
#import "EvtEditEventTitleCell.h"
#import "EvtEditEventCoverCell.h"
#import "EvtEditEventDateCell.h"
#import "EvtEditEventViewModel.h"
#import <PGDatePicker/PGDatePickManager.h>

NSString *EvtEditEventSuccessNotification = @"com.event.editventSuccess";

@interface EvtEditEventController ()<UITableViewDelegate,TZImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   EvtEditEventViewModel     *viewModel;
/** 保存按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *saveItem;

@end

@implementation EvtEditEventController

#pragma mark - init
+ (instancetype)editEventController{
    return [self editEventControllerWithModel:nil];
}
+ (instancetype)editEventControllerWithModel:(EvtEventModel *)model{
    EvtEditEventController *vc = [self viewControllerWithStoryBoard:EvtEventStoryboard];
    vc.viewModel = [EvtEditEventViewModel viewModelWithModel:model];
    
    return vc;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindActions];
}

#pragma mark - setupUI
- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    RAC(self.saveItem,enabled) = RACObserve(self.viewModel, isSaveEnable);
    self.navigationItem.rightBarButtonItem = self.saveItem;
    
    [self configDataSource];
}
- (void)configDataSource{
    //设置数据源。json配置化
    [self.tableView zh_createDataSource];
    //新建section
    ZHTableViewSection *sectionData = [ZHTableViewSection new];
    [self.tableView zh_addSection:sectionData];
    
    [self.tableView zh_addItems:self.viewModel.dataSource atSection:0];
    [self.tableView reloadData];
}
- (void)bindActions{
    @weakify(self)
    [self.viewModel.selectDateSubject subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self showDatePickerWithIndexPath:indexPath];
    }];
    [self.viewModel.selectPhotoSubject subscribeNext:^(NSIndexPath *x) {
        @strongify(self)
        [self selectPhotoEventWithIndexPath:x];
    }];
    
    [[self.viewModel.saveCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EvtEditEventSuccessNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZHTableViewItem *item = [self.tableView zh_itemAtIndexPath:indexPath];
    return item.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - event handler
- (void)selectPhotoEventWithIndexPath:(NSIndexPath *)path{
    ZHTableViewItem *item = [self.tableView zh_itemAtIndexPath:path];
    EvtEditEventCoverViewModel *model = item.data;
    
    __weak typeof(self)weakself = self;
    TZImagePickerController *imagePickVC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickVC.showSelectBtn = NO;
    imagePickVC.allowCrop = YES;
    
    CGFloat cropHeight = ZHScreenWidth * 9 / 16;
    imagePickVC.cropRect = CGRectMake(0,(ZHScreenHeight - cropHeight)/2 ,ZHScreenWidth,cropHeight) ;
    
    [imagePickVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [model setCoverImage:photos.lastObject];
        [weakself.tableView reloadData];
    }];
    [self presentViewController:imagePickVC animated:YES completion:nil];
}
- (void)showDatePickerWithIndexPath:(NSIndexPath *)path{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
    });
    
    EvtEditEventDateViewModel *model = [self.tableView zh_itemAtIndexPath:path].data;
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        model.dateComp = dateComponents;
    };
    datePicker.datePickerMode = PGDatePickerModeDateHour;
    
    [self presentViewController:datePickManager animated:false completion:nil];
}
- (void)clickSaveEvent:(UIBarButtonItem *)sender{
    [self.viewModel.saveCommand execute:nil];
}
#pragma mark - getter&setter
- (UIBarButtonItem *)saveItem{
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveEvent:)];
    }
    return _saveItem;
}
@end
