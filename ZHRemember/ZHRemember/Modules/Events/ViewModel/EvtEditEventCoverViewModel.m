//
//  EvtEditEventCoverViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "EvtEditEventCoverViewModel.h"

@interface EvtEditEventCoverViewModel()

@property (nonatomic, copy)     NSString    *coverString;

@end

@implementation EvtEditEventCoverViewModel

+ (instancetype)viewModelWithCoverURL:(NSString *)coverString{
    EvtEditEventCoverViewModel *vm = [self new];
    vm.coverString = coverString;
    
    return vm;
}
- (void)setCover:(UIImage *)cover{
    _cover = cover;
    self.coverData = UIImagePNGRepresentation(cover);
}
@end
