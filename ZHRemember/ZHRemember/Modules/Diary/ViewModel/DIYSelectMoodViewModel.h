//
//  DIYSelectMoodViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/9/3.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DIYSelectMoodModel;

typedef enum : NSUInteger {
    DIYMoodSectionTypeMood = 0,
    DIYMoodSectionTypeWeather,
    DIYMoodSectionTypePaper,
} DIYMoodSectionType;

/**
 选择心情、天气页面vm
 */
@interface DIYSelectMoodViewModel : NSObject

/** 选择的心情图片名*/
@property (nonatomic, copy)     NSString    *moodImageName;
/** 选择的天气图片名*/
@property (nonatomic, copy)     NSString    *weatherImageName;


#pragma mark - collectionView datasource
- (NSInteger)numberOfsections;
- (NSInteger)nuberOfItemsInSection:(NSInteger)section;
- (BOOL)isItemSelectedAtIndexPath:(NSIndexPath *)path;
- (void)selectedItemAtIndexPath:(NSIndexPath *)path;

@end


