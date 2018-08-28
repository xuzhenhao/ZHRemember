//
//  MySettingViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MySettingViewModel.h"

@interface MySettingViewModel()



@end

@implementation MySettingViewModel

+ (instancetype)viewModelWithName:(NSString *)name
                         subTitle:(NSString *)subTitle
                             type:(MySettingType)type
                    showIndicator:(BOOL)isShowIndicator
                   showBottomLine:(BOOL)isShowBottomLine;{
    MySettingViewModel *vm = [MySettingViewModel new];
    vm.name = name;
    vm.subTitle = subTitle;
    vm.type = type;
    vm.isShowIndicator = isShowIndicator;
    vm.isShowBottomLine = isShowBottomLine;
    
    return vm;
}

@end
