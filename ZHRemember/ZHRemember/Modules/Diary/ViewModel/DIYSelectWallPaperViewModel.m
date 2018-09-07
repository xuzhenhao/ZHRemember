//
//  DIYSelectWallPaperViewModel.m
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import "DIYSelectWallPaperViewModel.h"

@implementation DIYSelectWallPaperViewModel

- (NSInteger)numberOfSections{
    return 2;
}
- (NSInteger)numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 60;
    }
    return 0;
}

- (NSString *)imageNameOfIndex:(NSIndexPath *)path{
    NSString *name = @"letter-paper";
    if (path.section == 0) {
        name = [NSString stringWithFormat:@"%@%zd",name,path.item];
    }else if (path.section == 1){
        NSInteger index = path.item;
        if (index < 10) {
            index += 10;
        }
        name = [NSString stringWithFormat:@"%@%zd",name,path.item];
    }
    
    return name;
    
}
@end
