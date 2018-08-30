//
//  DIYDiaryTarget.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/30.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYDiaryTarget.h"
#import "DIYDiaryListViewController.h"

@implementation DIYDiaryTarget

- (UIViewController *)diaryListViewController{
    UIViewController *diaryVC = [DIYDiaryListViewController diaryListViewController];
    
    return diaryVC;
}
@end
