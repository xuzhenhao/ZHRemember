//
//  ZHMediator+ZHDiary.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "ZHMediator+ZHDiary.h"
#define DiaryModuleTargetName @"DIYDiaryTarget"

@implementation ZHMediator (ZHDiary)

- (UIViewController *)zh_diaryListViewController{
    UIViewController *vc = [self performTarget:DiaryModuleTargetName action:@"diaryListViewController" params:nil];
    return vc ?: [UIViewController new];
}
@end
