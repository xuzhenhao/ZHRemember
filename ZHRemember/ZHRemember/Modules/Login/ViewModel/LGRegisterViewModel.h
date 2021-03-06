//
//  LGRegisterViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/23.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRegisterViewModel : NSObject

/** 手机号地区码*/
@property (nonatomic, copy)     NSString    *zoneCode;
/** 格式化*/
@property (nonatomic, copy)     NSString    *zoneCodeDesc;
/** 手机号*/
@property (nonatomic, copy)     NSString    *mobilePhone;
/** 密码*/
@property (nonatomic, copy)     NSString    *password;
/** 验证码*/
@property (nonatomic, copy)     NSString    *smsCode;
/** 验证码按钮描述*/
@property (nonatomic, copy)     NSString    *smsBtnDesc;
/** 错误信息*/
@property (nonatomic, strong,readonly)   NSError     *error;


/**注册事件指令*/
@property (nonatomic, strong)   RACCommand     *registCommad;
/** 获取验证码指令*/
@property (nonatomic, strong)   RACCommand     *smsCommand;

@end
