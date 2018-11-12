//
//  DIYSelectMoodViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/3.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectMoodViewModel.h"

@interface DIYSelectMoodViewModel()

@property (nonatomic, strong)   NSMutableArray<NSIndexPath *>     *selectedIndexs;

@end

@implementation DIYSelectMoodViewModel

#pragma mark - collectionView datasource
- (NSInteger)numberOfsections{
    return 3;
}
- (NSInteger)nuberOfItemsInSection:(NSInteger)section{
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
- (DIYSelectMoodModel *)modelOfSection:(NSInteger)section row:(NSInteger)row{
    return nil;
}
- (BOOL)isItemSelectedAtIndexPath:(NSIndexPath *)path{
    NSIndexPath *selectedPath = self.selectedIndexs[path.section];
    return selectedPath.row == path.row ? YES :NO;
}
- (void)selectedItemAtIndexPath:(NSIndexPath *)path{
    self.selectedIndexs[path.section] = path;
    
    if (path.section == DIYMoodSectionTypeMood) {
        self.moodImageName = [NSString diary_moodImageNameOfIndex:path.item];
    }else if (path.section == DIYMoodSectionTypeWeather){
        self.weatherImageName = [NSString diary_weatherImageNameOfIndex:path.item];
    }
}

#pragma mark - getter
- (NSMutableArray<NSIndexPath *> *)selectedIndexs{
    if (!_selectedIndexs) {
        _selectedIndexs = [[NSMutableArray  alloc] initWithObjects:[NSIndexPath indexPathForItem:-1 inSection:0],
            [NSIndexPath indexPathForItem:-1 inSection:1],
            [NSIndexPath indexPathForItem:-1 inSection:2],
            nil];
    }
    return _selectedIndexs;;
}

@end


