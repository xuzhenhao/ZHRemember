//
//  DIYDiaryListCellViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/31.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHDiaryModel;

extern CGFloat DIYDiaryListCellHeadTimeViewHeight;
extern CGFloat DIYDiaryListCellDiaryViewHeight;

@interface DIYDiaryListCellViewModel : NSObject

/** 是否显示头部时间，(只有当月的第一条日记显示)*/
@property (nonatomic, assign)   BOOL      isShowHeadTime;
/** 是否显示日的时间信息(只有当天的第一条日记显示)*/
@property (nonatomic, assign)   BOOL      isShowDayTime;
/** 年月时间描述*/
@property (nonatomic, copy)     NSString    *yearMonthDesc;
/** 日时间描述*/
@property (nonatomic, copy)     NSString    *dayDesc;
/** 小时时间描述*/
@property (nonatomic, copy)     NSString    *hourDesc;
/** 星期时间描述*/
@property (nonatomic, copy)     NSString    *weekDesc;


/** cell高度*/
@property (nonatomic, assign)   CGFloat      cellHeight;
/** 日记文本内容*/
@property (nonatomic, copy)     NSString    *diaryContent;


+ (instancetype)viewModelWithModel:(ZHDiaryModel *)model;

@end
