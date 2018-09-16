//
//  DIYPDFTemplateView.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYPDFTemplateView.h"
#import "DIYPDFCalendarView.h"
#import <YYText/YYText.h>
#import "ZHDiaryModel.h"

NSInteger margin = 20;

@interface DIYPDFTemplateView()

@property (nonatomic, strong)   ZHDiaryModel     *diary;

/** 年月日时间*/
@property (nonatomic, strong)   UILabel     *yearTimeLabel;
/** 小时分钟时间*/
@property (nonatomic, strong)   UILabel     *hourTimeLabel;

/** 信纸*/
@property (nonatomic, strong)   UIImageView     *letterImageView;
/** 日历*/
@property (nonatomic, strong)   DIYPDFCalendarView     *calendarView;
/** 分割线*/
@property (nonatomic, strong)   UIView     *lineView;
/** 天气图片*/
@property (nonatomic, strong)   UIImageView     *weatherImageView;
/** 心情图片*/
@property (nonatomic, strong)   UIImageView     *moodImageView;
/** 日记图片*/
@property (nonatomic, strong)   UIImageView     *diaryImageView;

@property (nonatomic, strong)   YYLabel     *textLabel;

@end

@implementation DIYPDFTemplateView
+ (instancetype)templateViewWithModel:(ZHDiaryModel *)model{
    DIYPDFTemplateView *view = [[DIYPDFTemplateView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    view.diary = model;
    [view setupView];
    [view setupConstraints];
    return view;
}

- (void)setupView{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.diary.unixTime.integerValue];
    NSString *yearTimeFormat = [date formattedDateWithFormat:@"yyyy年MM月dd日" locale:[NSLocale systemLocale]];
    NSString *weekTime = [date getWeekDay];
    NSString *hourTimeFormat = [date formattedDateWithFormat:@"HH:mm" locale:[NSLocale systemLocale]];
    NSString *dayFormat = nil;
    if (date.hour < 12) {
        dayFormat = @"早上";
    }else if (date.hour < 18){
        dayFormat = @"下午";
    }else{
        dayFormat = @"晚上";
    }
    
    self.yearTimeLabel.text = [NSString stringWithFormat:@"%@ %@",yearTimeFormat,weekTime];
    self.hourTimeLabel.text = [NSString stringWithFormat:@"%@ %@",hourTimeFormat,dayFormat];
    self.textLabel.text = self.diary.diaryText;
    if (self.diary.diaryImageURL) {
        self.diaryImageView.hidden = NO;
        [self.diaryImageView sd_setImageWithURL:[NSURL URLWithString:self.diary.diaryImageURL]];
    }else{
        self.diaryImageView.hidden = YES;
    }
    
    
    [self addSubview:self.letterImageView];
    [self addSubview:self.yearTimeLabel];
    
    self.calendarView = [DIYPDFCalendarView calendarViewWithSize:CGSizeMake(50, 50) month:date.month day:date.day];
    [self addSubview:self.calendarView];
    [self addSubview:self.lineView];
    
    [self addSubview:self.hourTimeLabel];
    [self addSubview:self.weatherImageView];
    [self addSubview:self.moodImageView];
    [self addSubview:self.diaryImageView];
    [self addSubview:self.textLabel];
}
- (void)setupConstraints{
    [self.yearTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(margin);
        make.left.mas_equalTo(self.mas_left).offset(margin);
    }];
    [self.letterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-margin);
        make.top.mas_equalTo(self.mas_top).offset(margin);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(margin);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(self.yearTimeLabel.mas_right).
        offset(20);
        make.top.mas_equalTo(self.yearTimeLabel.mas_bottom).
        offset(3);
    }];
    [self.hourTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(margin);
        make.centerY.
        mas_equalTo(self.weatherImageView.mas_centerY);
    }];
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hourTimeLabel.mas_right);
        make.top.
        mas_equalTo(self.lineView.mas_bottom);
    }];
    [self.moodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.
        mas_equalTo(self.weatherImageView.mas_right);
        make.centerY.
        mas_equalTo(self.weatherImageView.mas_centerY);
    }];
    [self.diaryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.calendarView.mas_bottom).
        offset(10);
        make.size.mas_equalTo(CGSizeMake(280, 158));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    __weak typeof(self)weakself = self;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (weakself.diary.diaryImageURL) {
            make.top.
            mas_equalTo(self.diaryImageView.mas_bottom);
        }else{
            make.top.mas_equalTo(self.calendarView.mas_bottom).offset(10);
        }
        make.left.mas_equalTo(self.mas_left).offset(margin);
        make.right.mas_equalTo(self.mas_right).offset(-margin);
    }];
}

#pragma mark - getter
- (UILabel *)yearTimeLabel{
    if (!_yearTimeLabel) {
        _yearTimeLabel = [UILabel new];
        _yearTimeLabel.textColor = [UIColor blackColor];
        _yearTimeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _yearTimeLabel;
}
- (UILabel *)hourTimeLabel{
    if (!_hourTimeLabel) {
        _hourTimeLabel = [UILabel new];
        _hourTimeLabel.textColor = [UIColor blackColor];
        _hourTimeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _hourTimeLabel;
}

- (UIImageView *)letterImageView{
    if (!_letterImageView) {
        _letterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"letter-paper0"]];
    }
    return _letterImageView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}
- (UIImageView *)weatherImageView{
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diary-weather0"]];
    }
    return _weatherImageView;
}
- (UIImageView *)moodImageView{
    if (!_moodImageView) {
        _moodImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diary-mood0"]];
    }
    return _moodImageView;
}
- (UIImageView *)diaryImageView{
    if (!_diaryImageView) {
        _diaryImageView = [UIImageView new];
    }
    return _diaryImageView;
}
- (YYLabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [YYLabel new];
        _textLabel.font = [UIFont systemFontOfSize:16];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 0;
        _textLabel.preferredMaxLayoutWidth = 320 - 2 *margin;
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 24;
        _textLabel.linePositionModifier = mod;
    }
    return _textLabel;
}
@end
