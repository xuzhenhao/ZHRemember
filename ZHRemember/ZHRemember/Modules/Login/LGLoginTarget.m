//
//  LGLoginTarget.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "LGLoginTarget.h"
#import "LGRegisterViewController.h"

@implementation LGLoginTarget

- (UIViewController *)registerViewController{
    UIViewController *vc = [LGRegisterViewController registerViewController];
    return vc;
}
@end
