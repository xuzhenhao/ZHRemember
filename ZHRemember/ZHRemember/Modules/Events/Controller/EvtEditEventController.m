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
#import "EvtEventDetailViewModel.h"

NSString *EvtEditEventSuccessNotification = @"com.event.editventSuccess";

@interface EvtEditEventController ()<UITableViewDelegate,TZImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   EvtEditEventViewModel     *viewModel;
@property (nonatomic, strong)   EvtEventDetailViewModel     *detailViewModel;
/** 保存按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *saveItem;
/** 删除按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *deleteItem;
/** 是否编辑，编辑时显示删除按钮*/
@property (nonatomic, assign)   BOOL      isEditStatus;

@end

@implementation EvtEditEventController

#pragma mark - init
+ (instancetype)editEventController{
    return [self editEventControllerWithModel:nil];
}
+ (instancetype)editEventControllerWithModel:(EvtEventModel *)model{
    EvtEditEventController *vc = [self viewControllerWithStoryBoard:EvtEventStoryboard];
    vc.viewModel = [EvtEditEventViewModel viewModelWithModel:model];
    vc.isEditStatus = model ? YES : NO;
    
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
    if (!self.isEditStatus) {
        self.navigationItem.rightBarButtonItem = self.saveItem;
    }else{
        self.navigationItem.rightBarButtonItems = @[self.saveItem,self.deleteItem];
    }
    
    
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
    
    [[self.detailViewModel.deleteCommand.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        BOOL success = [x boolValue];
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EvtEditEventSuccessNotification object:nil];
            [HBHUDManager showMessage:@"已删除" done:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [HBHUDManager showMessage:@"删除失败，请稍后重试"];
        }
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
    imagePickVC.barItemTextColor = [UIColor zh_themeColor];
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
- (void)didClickDeleteEventItem:(UIBarButtonItem *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"确定要删除当前纪念日吗?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.detailViewModel.deleteCommand execute:self.viewModel.eventId];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - getter&setter
- (UIBarButtonItem *)saveItem{
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveEvent:)];
    }
    return _saveItem;
}
- (UIBarButtonItem *)deleteItem{
    if (!_deleteItem) {
        _deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDeleteEventItem:)];
    }
    return _deleteItem;
}
- (EvtEventDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [EvtEventDetailViewModel new];
    }
    return _detailViewModel;
}
@end
