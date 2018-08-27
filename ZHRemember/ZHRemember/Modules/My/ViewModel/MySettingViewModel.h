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
    MySettingTypeTag,//标签管理
    MySettingTypeOther,
    MySettingTypeLogout,//登出
} MySettingType;

@interface MySettingViewModel : NSObject
/** 设置的项目名称*/
@property (nonatomic, copy)     NSString    *name;
/** 图片名称*/
@property (nonatomic, copy)     NSString    *imageName;
/** 项目类型*/
@property (nonatomic, assign)   MySettingType      type;

/**
 工厂方法

 @param name 名字
 @param imageName 图片名
 @param type 类型
 @return 实例
 */
+ (instancetype)viewModelWithName:(NSString *)name
                            image:(NSString *)imageName
                             type:(MySettingType)type;

@end
