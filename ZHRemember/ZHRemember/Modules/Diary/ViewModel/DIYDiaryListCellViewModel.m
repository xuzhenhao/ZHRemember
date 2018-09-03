//
//  DIYDiaryListCellViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryListCellViewModel.h"
#import "ZHDiaryModel.h"

CGFloat DIYDiaryListCellHeadTimeViewHeight = 25;
CGFloat DIYDiaryListCellDiaryViewHeight = 75;

@interface DIYDiaryListCellViewModel()
/** <#desc#>*/
@property (nonatomic, strong)   ZHDiaryModel     *model;

@end

@implementation DIYDiaryListCellViewModel

+ (instancetype)viewModelWithModel:(ZHDiaryModel *)model{
    DIYDiaryListCellViewModel *viewModel = [DIYDiaryListCellViewModel new];
    viewModel.model = model;
    viewModel.diaryContent = model.diaryText;
    [viewModel formatTime:model.unixTime];
    viewModel.diaryPhotoUrl = model.diaryImageURL;
    viewModel.weatherImageName = model.weatherImageName;
    viewModel.moodImageName = model.moodImageName;
    
    return viewModel;
}

#pragma mark - utils
- (void)formatTime:(NSString *)unixTime{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime.integerValue];
    NSString *dateFormat = [date formattedDateWithFormat:@"yyyy年MM月,dd,HH:mm" locale:[NSLocale systemLocale]];
    NSArray *tempA = [dateFormat componentsSeparatedByString:@","];
    self.yearMonthDesc = tempA[0];
    self.dayDesc = tempA[1];
    self.hourDesc = tempA[2];
    self.weekDesc = [date getWeekDay];
    
}

#pragma mark - getter
- (CGFloat)cellHeight{
    if (self.isShowHeadTime) {
        return DIYDiaryListCellDiaryViewHeight + DIYDiaryListCellHeadTimeViewHeight;
    }
    return DIYDiaryListCellDiaryViewHeight;
}
@end
