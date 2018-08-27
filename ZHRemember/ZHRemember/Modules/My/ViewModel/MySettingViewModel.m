//
//  MySettingViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MySettingViewModel.h"

@implementation MySettingViewModel

+ (instancetype)viewModelWithName:(NSString *)name
                            image:(NSString *)imageName
                             type:(MySettingType)type{
    MySettingViewModel *vm = [MySettingViewModel new];
    vm.name = name;
    vm.imageName = imageName;
    vm.type = type;
    
    return vm;
}
@end
