//
//  MySettingViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MySettingTypeAccount,//账户
    MySettingTypeGesture,//手势解锁
    MySettingTypeTag,//标签管理
    MySettingTypeThemeColor,//主题色
    MySettingTypeDayTip,//每日提醒
    MySettingTypeRecommand,//推荐鼓励
    MySettingTypeFeedback,//意见反馈
    MySettingTypeLogout,//登出
} MySettingType;

@interface MySettingViewModel : NSObject
/** 设置的项目名称*/
@property (nonatomic, copy)     NSString    *name;
/** 项目副内容*/
@property (nonatomic, copy)     NSString    *subTitle;
/** 图片名称*/
@property (nonatomic, copy)     NSString    *imageName;
/** 项目类型*/
@property (nonatomic, assign)   MySettingType      type;
@property (nonatomic, assign)   BOOL      isShowIndicator;
@property (nonatomic, assign)   BOOL      isShowBottomLine;
/** 重用标识符*/
@property (nonatomic, copy,readonly)     NSString    *reuserId;

/**
 工厂方法

 @param name 功能名字
 @param subTitle 副内容
 @param type 类型
 @param isShowIndicator 是否显示指示器
 @param isShowBottomLine 是否显示底部线条
 @return 实例
 */
+ (instancetype)viewModelWithName:(NSString *)name
                         subTitle:(NSString *)subTitle
                             type:(MySettingType)type
                    showIndicator:(BOOL)isShowIndicator
                   showBottomLine:(BOOL)isShowBottomLine;

@end
