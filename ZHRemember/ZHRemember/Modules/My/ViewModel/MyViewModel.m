//
//  MyViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/27.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "MyViewModel.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MyViewModel()
/** 数据源*/
@property (nonatomic, strong)   NSArray<MySettingViewModel *>     *items;

@end

@implementation MyViewModel

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup{
    MySettingViewModel *accountItem = [MySettingViewModel viewModelWithName:@"账户" image:nil type:MySettingTypeAccount];
    MySettingViewModel *tagItem = [MySettingViewModel viewModelWithName:@"标签" image:nil type:MySettingTypeTag];
    MySettingViewModel *logOutItem = [MySettingViewModel viewModelWithName:@"登出" image:nil type:MySettingTypeLogout];
    
    self.items = @[accountItem,tagItem,logOutItem];
}
#pragma mark - tableView
- (NSInteger)numberOfItems{
    return self.items.count;
}
- (CGFloat)itemHeight{
    return 44;
}
- (id)viewModelForRow:(NSInteger)row section:(NSInteger)section{
    return self.items[row];
}
- (MySettingType)itemTypeOfRow:(NSInteger)row section:(NSInteger)section{
    MySettingViewModel *vm = [self viewModelForRow:row section:section];
    return vm.type;
}
#pragma mark - public method
- (void)logout{
    [AVUser logOut];
}

@end
