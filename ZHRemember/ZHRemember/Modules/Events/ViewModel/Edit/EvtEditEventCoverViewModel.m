//
//  EvtEditEventCoverViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventCoverViewModel.h"
#import "ZHCommonApi.h"

@interface EvtEditEventCoverViewModel()

@property (nonatomic, copy)     NSString    *coverURLString;
@property (nonatomic, strong)   UIImage     *coverImg;

@end

@implementation EvtEditEventCoverViewModel

+ (instancetype)viewModelWithCoverURL:(NSString *)coverString{
    EvtEditEventCoverViewModel *vm = [self new];
    vm.coverURLString = coverString;
    
    return vm;
}
- (void)setCoverImage:(UIImage *)image{
    if (!image) {
        return;
    }
    self.coverImg = image;
    
    [self.uploadPhotoSubject sendNext:@(NO)];
    __weak typeof(self)weakself = self;
    [ZHCommonApi uploadImage:image done:^(NSString *urlString, NSDictionary *error) {
        weakself.coverURLString = urlString;
        [weakself.uploadPhotoSubject sendNext:@(YES)];
    }];
}


@end
