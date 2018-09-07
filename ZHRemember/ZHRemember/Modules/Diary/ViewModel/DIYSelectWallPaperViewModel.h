//
//  DIYSelectWallPaperViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/7.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIYSelectWallPaperViewModel : NSObject
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)imageNameOfIndex:(NSIndexPath *)path;

@end
