//
//  EvtEditEventCoverViewModel.h
//  ZHRemember
//
//  Created by xuzhenhao on 2018/8/14.
//  Copyright © 2018年 xuzhenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 编辑事件封面对应vm
 */
@interface EvtEditEventCoverViewModel : NSObject

@property (nonatomic, copy, readonly)     NSString    *coverURLString;
@property (nonatomic, strong, readonly)   UIImage     *coverImg;

+ (instancetype)viewModelWithCoverURL:(NSString *)coverString;

- (void)setCoverImage:(UIImage *)image;

@property (nonatomic, strong)   RACSubject     *selectPhotoSubject;

@end
