//
//  LGResetPwdViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/28.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 重设密码VM
 */
@interface LGResetPwdViewModel : NSObject

/** 手机号*/
@property (nonatomic, copy)     NSString    *mobilePhone;
/** 密码*/
@property (nonatomic, copy)     NSString    *password;
/** 验证码*/
@property (nonatomic, copy)     NSString    *smsCode;
/** 验证码按钮描述*/
@property (nonatomic, copy)     NSString    *smsBtnDesc;

/** 重设密码指令*/
@property (nonatomic, strong)   RACCommand     *resetCommand;
/** 获取验证码指令*/
@property (nonatomic, strong)   RACCommand     *smsCommand;

@end
