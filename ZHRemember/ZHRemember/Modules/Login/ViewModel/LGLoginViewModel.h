//
//  LGLoginViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/24.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 登录VM
 */
@interface LGLoginViewModel : NSObject

/** 账户名*/
@property (nonatomic, copy)     NSString    *account;
/** 密码*/
@property (nonatomic, copy)     NSString    *password;
/** 错误信息*/
@property (nonatomic, strong,readonly)   NSError     *error;

/** 登录命令*/
@property (nonatomic, strong)   RACCommand     *loginCommand;

@end
