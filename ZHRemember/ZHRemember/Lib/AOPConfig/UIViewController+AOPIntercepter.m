//
//  UIViewController+AOPIntercepter.m
//  aopDemo
//
//  Created by cloud on 2018/8/9.
//  Copyright © 2018年 cloud. All rights reserved.
//

#import "UIViewController+AOPIntercepter.h"
#import <objc/runtime.h>
#import "UIViewController+AOPBase.h"

@implementation UIViewController (AOPIntercepter)

//+ (void)load{
//    [super load];
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        //事实上hook的都是父类方法，子类中必须调用[super viewDidLoad];才会生效
//        [self hookViewDidLoadMethod];
//        [self hookViewWillAppearMethod];
//    });
    
//}
#pragma mark - hook method
+ (void)hookMethodWithOriginSEL:(SEL)originalSelector swizzledSEL:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
+ (void)hookViewDidLoadMethod{
    SEL originalSelector = @selector(viewDidLoad);
    SEL swizzledSelector = @selector(hook_viewDidLoad);
    [self hookMethodWithOriginSEL:originalSelector swizzledSEL:swizzledSelector];
}
+ (void)hookViewWillAppearMethod{
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(hook_viewWillAppear:);
    [self hookMethodWithOriginSEL:originalSelector swizzledSEL:swizzledSelector];
}


#pragma mark - replace method
- (void)hook_viewDidLoad{
    [self hook_viewDidLoad];
    
}
- (void)hook_viewWillAppear:(BOOL)animated{
    [self hook_viewWillAppear:animated];
    //避免hook到不相干的类，执行方法前最好有判断机制如果协议，判断是否是目标对象
    self.view.backgroundColor = [UIColor redColor];
}

@end
