//
//  DIYWriteDiaryViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHDiaryModel;

/**
 写日记页面vm
 */
@interface DIYWriteDiaryViewModel : NSObject

/** 日历区域，月份描述*/
@property (nonatomic, copy)     NSString    *monthDesc;
/** 日历区域，天描述*/
@property (nonatomic, copy)     NSString    *dayDesc;
/** 日历区域，星期描述*/
@property (nonatomic, copy)     NSString    *weekDesc;
/** 日历区域，小时描述*/
@property (nonatomic, copy)     NSString    *hourDesc;
/** 天气图片名称*/
@property (nonatomic, copy)     NSString    *weathImageName;
/** 心情图片名称*/
@property (nonatomic, copy)     NSString    *moodImageName;
/** 信纸图片名称*/
@property (nonatomic, copy)     NSString    *letterImageName;
/** 日记图片*/
@property (nonatomic, copy)     NSString    *diaryImageURL;
/** 日记文本*/
@property (nonatomic, copy)     NSString    *diaryText;
@property (nonatomic, copy,readonly)     NSString    *diaryId;

/** 保存日记*/
@property (nonatomic, strong)   RACCommand     *saveDiaryCommand;
/** 删除日记*/
@property (nonatomic, strong)   RACCommand     *deleteCommand;
/** 发布日记奖励*/
@property (nonatomic, strong)   RACCommand     *rewardCommand;
/** 上传图片回到*/
@property (nonatomic, strong)   RACSubject     *uploadSubject;

/**
 默认配置
 */
+ (instancetype)defaultViewModel;
+ (instancetype)viewModelWithModel:(ZHDiaryModel *)model;

- (void)updateTimeWithDateComponents:(NSDateComponents *)components;
- (void)updateDiaryImage:(UIImage *)image;

@end
