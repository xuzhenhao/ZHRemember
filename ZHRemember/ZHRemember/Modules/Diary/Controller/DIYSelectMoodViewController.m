//
//  DIYSelectMoodViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectMoodViewController.h"
#import "DIYDiaryConfig.h"
#import "DIYSelectMoodCell.h"
#import "DIYSelectMoodViewModel.h"

@interface DIYSelectMoodViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
/** 保存按钮*/
@property (nonatomic, strong)   UIBarButtonItem     *saveItem;

@property (nonatomic, strong)   DIYSelectMoodViewModel     *viewModel;

@end

@implementation DIYSelectMoodViewController
+ (instancetype)viewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.title = @"选择心情&天气";
    self.navigationItem.rightBarButtonItem = self.saveItem;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case DIYMoodSectionTypeMood:
            return 10;
            break;
        case DIYMoodSectionTypeWeather:
            return 7;
            break;
        default:
            break;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DIYSelectMoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DIYSelectMoodCell" forIndexPath:indexPath];
    
    BOOL isSelected = [self.viewModel isItemSelectedAtIndexPath:indexPath];
    [cell updateWithIndexPath:indexPath isSelected:isSelected];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewModel selectedItemAtIndexPath:indexPath];
    [self.collectionView reloadData];
}

#pragma mark - action
- (void)didClickSaveItem:(UIBarButtonItem *)sender{
    if (self.selectMoodWeatherCallback) {
        self.selectMoodWeatherCallback(self.viewModel.moodImageName, self.viewModel.weatherImageName, nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (DIYSelectMoodViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [DIYSelectMoodViewModel new];
    }
    return _viewModel;
}
- (UIBarButtonItem *)saveItem{
    if (!_saveItem) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickSaveItem:)];
    }
    return _saveItem;
}

@end
