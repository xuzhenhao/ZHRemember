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
@property (nonatomic, strong)   NSArray     *sections;

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
    NSString *userName = [AVUser currentUser].username;
    
    MySettingViewModel *accountItem = [MySettingViewModel viewModelWithName:@"帐户" subTitle:userName type:MySettingTypeAccount showIndicator:NO showBottomLine:NO];
    
    MySettingViewModel *tagItem = [MySettingViewModel viewModelWithName:@"标签管理" subTitle:@"" type:MySettingTypeTag showIndicator:YES showBottomLine:YES];
    MySettingViewModel *colorItem = [MySettingViewModel viewModelWithName:@"主题色" subTitle:nil type:MySettingTypeThemeColor showIndicator:YES showBottomLine:YES];
    MySettingViewModel *tipItem = [MySettingViewModel viewModelWithName:@"每日提醒" subTitle:nil type:MySettingTypeDayTip showIndicator:YES showBottomLine:NO];
    
//    MySettingViewModel *recomandItem = [MySettingViewModel viewModelWithName:@"推荐鼓励" subTitle:nil type:MySettingTypeRecommand showIndicator:NO showBottomLine:YES];
    MySettingViewModel *feedbackItem = [MySettingViewModel viewModelWithName:@"意见反馈" subTitle:nil type:MySettingTypeFeedback showIndicator:YES showBottomLine:NO];
    
    MySettingViewModel *logOutItem = [MySettingViewModel viewModelWithName:@"退出登录" subTitle:@"" type:MySettingTypeLogout showIndicator:NO showBottomLine:NO];
    
    NSArray *sectionOne = @[accountItem];
    NSArray *sectionTwo = @[tagItem,colorItem,tipItem];
    NSArray *sectionThree = @[feedbackItem];
    NSArray *sectionFor = @[logOutItem];
    self.sections = @[sectionOne,sectionTwo,sectionThree,sectionFor];
}
#pragma mark - tableView
- (NSInteger)numberOfSections{
    return self.sections.count;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    NSArray *sectionArray = self.sections[section];
    return sectionArray.count;
}
- (CGFloat)itemHeight{
    return 44;
}
- (id)viewModelForRow:(NSInteger)row section:(NSInteger)section{
    NSArray *sectionArr = self.sections[section];
    return sectionArr[row];
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
