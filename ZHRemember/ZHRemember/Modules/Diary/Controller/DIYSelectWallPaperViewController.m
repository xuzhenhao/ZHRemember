//
//  DIYSelectWallPaperViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectWallPaperViewController.h"
#import "DIYDiaryConfig.h"
#import "DIYSelectWallPaperViewModel.h"
#import "DIYSelectPaperCell.h"

@interface DIYSelectWallPaperViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)   DIYSelectWallPaperViewModel     *viewModel;

@end

@implementation DIYSelectWallPaperViewController
+ (instancetype)paperViewController{
    return [self viewControllerWithStoryBoard:DIYModuleStoryBoardName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.viewModel numberOfSections];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.viewModel numberOfItemsInSection:section];
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DIYSelectPaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DIYSelectPaperCell" forIndexPath:indexPath];
    [cell updateWithImageName:[self.viewModel imageNameOfIndex:indexPath]];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"test" forIndexPath:indexPath];
    UILabel *titleLabel = [view viewWithTag:10086];
    if (indexPath.section == 0) {
        titleLabel.text = @"免费信纸";
    }else{
        titleLabel.text = @"付费信纸";
    }
    return view;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSString *imageName = [self.viewModel imageNameOfIndex:indexPath];
    if (self.selectPaperCallback) {
        self.selectPaperCallback(imageName);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - getter
- (DIYSelectWallPaperViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [DIYSelectWallPaperViewModel new];
    }
    return _viewModel;
}

@end
