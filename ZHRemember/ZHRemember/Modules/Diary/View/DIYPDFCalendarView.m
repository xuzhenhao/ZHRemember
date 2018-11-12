//
//  DIYPDFCalendarView.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/15.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYPDFCalendarView.h"

@interface DIYPDFCalendarView()

@property (nonatomic, assign)   NSInteger      month;
@property (nonatomic, assign)   NSInteger      day;

/** 月份*/
@property (nonatomic, strong)   UILabel     *monthLabel;
/** 天*/
@property (nonatomic, strong)   UILabel     *dayLabel;


@end

@implementation DIYPDFCalendarView

+ (instancetype)calendarViewWithSize:(CGSize)size
                               month:(NSInteger)month
                                 day:(NSInteger)day{
    DIYPDFCalendarView *view = [[DIYPDFCalendarView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.month = month;
    view.day = day;
    [view setupView];
    
    return view;
    
}

- (void)setupView{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIView *monthContentView = [UIView new];
    monthContentView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:monthContentView];
    [monthContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(20);
    }];
    
    [monthContentView addSubview:self.monthLabel];
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月",self.month];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(monthContentView);
    }];
    
    [self addSubview:self.dayLabel];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",self.day];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(monthContentView.mas_bottom).
        offset(5);
    }];
}

#pragma mark - getter
- (UILabel *)monthLabel{
    if (!_monthLabel) {
        _monthLabel = [UILabel new];
        _monthLabel.font = [UIFont systemFontOfSize:12];
        _monthLabel.textColor = [UIColor whiteColor];
    }
    return _monthLabel;
}
- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.font = [UIFont systemFontOfSize:18];
        _dayLabel.textColor = [UIColor blackColor];
    }
    return _dayLabel;
}



@end
