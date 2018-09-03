//
//  DIYDiaryListCell.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryListCell.h"
#import "DIYDiaryListCellViewModel.h"

@interface DIYDiaryListCell()
/**日记内容视图顶部间距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diaryViewTopLayout;
/**顶部区域日记时间*/
@property (weak, nonatomic) IBOutlet UILabel *headTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *statusBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *diaryBottomLineView;
@property (weak, nonatomic) IBOutlet UIView *calendarBgView;
@property (weak, nonatomic) IBOutlet UIView *midLineView;

@property (weak, nonatomic) IBOutlet UIView *callenderBgView;
/**显示几号*/
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
/**星期几*/
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
/**日记文本内容*/
@property (weak, nonatomic) IBOutlet UILabel *diaryTextLabel;
/**显示小时*/
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
/**显示天气*/
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
/**显示心情*/
@property (weak, nonatomic) IBOutlet UIImageView *moodImageView;

@end

@implementation DIYDiaryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSetup];
}
- (void)initSetup{
    self.topLineView.backgroundColor = [UIColor zh_themeColor];
    self.statusBottomLineView.backgroundColor = [UIColor zh_themeColor];
    self.diaryBottomLineView.backgroundColor = [UIColor zh_themeColor];
    self.calendarBgView.backgroundColor = [UIColor zh_themeColor];
    self.midLineView.backgroundColor = [UIColor zh_themeColor];
}

- (void)bindViewModel:(DIYDiaryListCellViewModel *)viewModel{
    //样式更新
    self.diaryViewTopLayout.constant = viewModel.isShowHeadTime ? DIYDiaryListCellHeadTimeViewHeight: 0;
    if (viewModel.isShowDayTime) {
        self.callenderBgView.hidden = NO;
        self.dayLabel.hidden = NO;
    }else{
        self.callenderBgView.hidden = YES;
        self.dayLabel.hidden = YES;
    }
    
    //内容更新
    self.diaryTextLabel.text = viewModel.diaryContent;
    self.headTimeLabel.text = viewModel.yearMonthDesc;
    self.dayLabel.text = viewModel.dayDesc;
    self.weekLabel.text = viewModel.weekDesc;
    self.hourLabel.text = viewModel.hourDesc;
}

@end