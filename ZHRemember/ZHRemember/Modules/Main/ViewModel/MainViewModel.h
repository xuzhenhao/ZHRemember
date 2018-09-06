//
//  MainViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/6.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewModel : NSObject

/** 同步服务端用户信息*/
@property (nonatomic, strong)   RACCommand     *syncUserCommand;

@end
