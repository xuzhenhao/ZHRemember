//
//  MyViewController.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/20.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyViewController.h"
#import "MyModuleHeader.h"

@interface MyViewController ()

@end

@implementation MyViewController
+ (instancetype)myViewController{
    return [self viewControllerWithStoryBoard:MyModuleStoryboard];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIViewController *vc = [[ZHMediator sharedInstance] eventTagController];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
